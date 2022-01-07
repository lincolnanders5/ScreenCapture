# frozen_string_literal: true

require_relative "screenlapse/version"

module Screenlapse
  class Error < StandardError; end

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
