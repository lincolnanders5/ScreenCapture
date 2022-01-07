require "thor"
require "fileutils"
require "pathname"
require "streamio-ffmpeg"
require "pry"

require "screenlapse"

module Screenlapse
  class CLI < Thor
    desc "capture (delay)", "capture a screenshot every (delay=2) seconds"
    option :root, type: :string, required: false, desc: "Location to find the archive in"
    def capture
      init_archive
      init_archive_date

      system "screencapture -x -r #{next_capture}"

      unless image_diff?
        puts "Duplicate images: #{File.basename(last_capture, ".*")} -> #{File.basename(next_capture, ".*")}"
        File.delete last_capture
      end
    end

    desc "record", "record continuous stream of screenshots"
    option :root, type: :string, required: false, desc: "Location to find the archive in"
    option :delay, type: :numeric, required: false, default: 2, desc: "How long to wait between screenshots"
    def record
      while true
        capture
        sleep options[:delay]
      end
    end

    desc "render", "render out a video of the current archive"
    option :root, type: :string, required: false, desc: "Location to find the archive in"
    option :fps, type: :numeric, required: false, default: 8, desc: "Set the number of frames per image"
    def render
      init_render
      system "ffmpeg -hide_banner -loglevel error -r #{options[:fps]} -f 'image2' -s 1920x1080 -i \"#{archive_path}/#{datefmt}/%05d.png\" -vcodec libx264 -crf 25 -pix_fmt yuv420p \"#{video_path}\""
      puts "wrote #{video_path}"
    end

    desc "open", "opens the last rendered movie"
    def open
      system "open #{movie_list.first}"
    end

    desc "clean", "cleans out history of recorded snapshots"
    def clean
      puts "cleaning #{archive_path}"
      FileUtils.rm_rf("#{archive_path}/.", secure: true)
    end

    desc "list", "lists all rendered movies"
    def list
      puts movie_list
    end

    private

    def video_path
      "#{archive_path}/render/#{Time.now.strftime("%m-%d-%H-%M")}.mp4"
    end

    def image_diff?(threshold=1000, downsample=4)
      res = system "perceptualdiff -threshold #{threshold} -downsample #{downsample} #{last_capture} #{next_capture} > /dev/null 2>&1"
      return !res
    end

    def next_capture
      "#{archive_path}/#{datefmt}/#{next_capture_num}.png"
    end

    def last_capture
      Dir.glob("#{archive_path}/#{datefmt}/*.png").max_by {|f| File.basename(f, ".*").to_i }
    end

    def next_capture_num
      int = 1
      int = File.basename(last_capture, ".*").to_i + 1 unless last_capture.nil?
      int.to_s.rjust(5, "0")
    end

    def init_archive
      unless File.exists?(archive_path) && File.directory?(archive_path)
        FileUtils.mkdir_p archive_path
      end
    end

    def init_archive_date
      unless File.exists?("#{archive_path}/#{datefmt}") && File.directory?("#{archive_path}/#{datefmt}")
        FileUtils.mkdir_p "#{archive_path}/#{datefmt}"
      end
    end

    def init_render
      unless File.exists?("#{archive_path}/render") && File.directory?("#{archive_path}/render")
        FileUtils.mkdir_p "#{archive_path}/render"
      end
    end

    def archive_path(root: ".")
      root = options[:root] unless options[:root].nil?
      File.expand_path root + "/.scarchive/"
    end

    def datefmt
      Time.now.strftime("%m/%d")
    end

    def movie_list
      Dir.glob(".scarchive/render/*.mp4")
         .sort_by{ |f| File.mtime(f) }
    end
  end
end