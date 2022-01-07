require "thor"
require "fileutils"
require "pathname"
require "streamio-ffmpeg"
require "pry"

require "screenlapse"
include Screenlapse

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
    option :root, type: :string, required: false, desc: "Location to find the archive in"
    def open
      puts "opening #{movie_list.first}"
      system "open #{movie_list.first}"
    end

    desc "clean", "cleans out history of recorded snapshots"
    option :root, type: :string, required: false, desc: "Location to find the archive in"
    def clean
      puts "cleaning #{archive_path}"
      FileUtils.rm_rf("#{archive_path}/.", secure: true)
    end

    desc "list", "lists all rendered movies"
    option :root, type: :string, required: false, desc: "Location to find the archive in"
    def list
      puts movie_list
    end
  end
end