# Screen Recorder
A simple repo to create a recording of your screen using a series of screenshots
automatically taken and sown together. Images are checked for difference in 

## Running
The easiest way to run is with the [foreman][foreman] gem installed,

``` shell
foreman run capture
foreman run render
```
Check Procfile for equivalent commands.


## Configuring
- `CAPTURE_DIR`: Where to store captured screenshots (defaults to
  `./.scarchive/MM/DD`)
- `OUTPUT_DIR`: Where the output video should be rendered to (defaults to
  `./.scarchive/render`). Only applies to `render` script, videos will be named
  `MM-DD HH-mm.mp4`
- `FPS`: For `render` script, specifies what the output video framerate should
  be (defaults to 60)
- `CLEAN`: For `render` script, optionally deletes all screenshots in
  `CAPTURE_DIR` after rendering the video.
- `DEBUG`: Show some debug print messages

[foreman]: https://github.com/ddollar/foreman
