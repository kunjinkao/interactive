
This is an example application of [rhizome][rhizome], a web server for  participative performances and installations. 

Basically, participants can use their mobile device to visit the rhizome page, and we use javascript to detect gyroscope data (modern browsers please!!), send OSC command to [SuperCollider](http://supercollider.github.io) through [rhizome][rhizome], changing the audio and visuals.

[rhizome]: https://github.com/sebpiq/rhizome

## Setup

1. Simpley run `npm install -g rhizome-server` to install rhizome, more docs on the [github repo](https://github.com/sebpiq/rhizome)

2. Install all the bower components use `bower install` (`npm install -g bower` to install bower)

4. Start the processing [sketch][sketch]

4. Take a look at the supercollider [file][scfile], evaluating some code(read comments as you go)

5. `rhizome config.js` to open the server, visit `localhost:8000`

[sketch]: https://github.com/kunjinkao/interactive/blob/master/sketch.pde
[scfile]: https://github.com/kunjinkao/interactive/blob/master/interactive.scd


## License

The processing sketch is based on Jack Jepson's [work](http://www.openprocessing.org/sketch/87338), licensed under [CC-BY-SA 3.0](http://creativecommons.org/licenses/by-sa/3.0/) and [GNU GPL license](http://creativecommons.org/licenses/GPL/2.0/).

We don't care about attribution. All other code is released under [CC0 1.0](http://creativecommons.org/publicdomain/zero/1.0/), it's all yours.