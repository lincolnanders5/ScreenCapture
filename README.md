# Screenlapse
A simple repo to create a recording of your screen using a series of screenshots
automatically taken and sown together. Images are checked for noticeable 
changes in the images before being fully saved. All images will be saved in a
relative `.scarchive` directory. Images can then be rendered into a video at a 
given frame rate or to a GIF with optional scaling.

## Installation
Install it yourself as:

    $ gem install screenlapse
    
    
Or, install and run locally:
```shell
git clone https://github.com/lincolnanders5/screenlapse.git
cd screenlapse
bin/screenlapse     # runs local version of command

rake install        # installs `screenlapse` command
screenlapse
```

## Running
Refer to `screenlapse help` for full usage. 

To start a session, run `screenlapse record` and leave it running in the 
background. When done, Control-C to stop the recording. `screenlapse render` 
can then be used to compile the images into one video.


## Examples
```shell
screenlapse record
screenlapse render --fps=24
screenlapse open                # View created movie

screenlapse render --gif --scale=0.3
screenlapse open                # View created gif

screenlapse clean
```


## License
The gem is available as open source under the terms of the 
[MIT License](https://opensource.org/licenses/MIT).
