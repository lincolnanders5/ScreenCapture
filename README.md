# Screenlapse
A simple repo to create a recording of your screen using a series of screenshots
automatically taken and sown together. Images are checked for difference in


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'screenlapse'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install screenlapse


## Configuring
- `CAPTURE_DIR`: Where to store captured screenshots (defaults to
  `./.scarchive/MM/DD`)
- `OUTPUT_DIR`: Where the output video should be rendered to (defaults to
  `./.scarchive/render`). Only applies to `render` script, videos will be named
  `MM-DD HH-mm.mp4`
- `FPS`: For `render` script, specifies what the output video framerate should
  be (defaults to 60)
- `SLEEP`: For `capture` script, sets how long the program should sleep for. For
  use with `LOOP=1`.
- `CLEAN`: For `render` script, optionally deletes all screenshots in
  `CAPTURE_DIR` after rendering the video.
- `DEBUG`: Show some debug print messages


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[foreman]: https://github.com/ddollar/foreman
