require "thor"
require "fileutils"

require "screenlapse"
include Screenlapse

module Screenlapse
  class CLI < Thor
    desc "capture (delay)", "capture a screenshot every (delay=2) seconds"
    option :root, type: :string, required: false, desc: "Location to find the archive in"
    def capture
      init_dir archive_path
      init_dir "#{archive_path}/#{datefmt}"

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
    option :root, type: :string, desc: "Location to find the archive in"
    option :fps, type: :numeric, default: 8, desc: "Set the number of frames per image"
    option :gif, type: :boolean, desc: "render a gif instead of a video"
    def render
      init_dir "#{archive_path}/render"
      options[:gif] ? render_gif(options[:fps]) : render_video(options[:fps])
      puts "wrote #{options[:gif] ? gif_path : video_path}"
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