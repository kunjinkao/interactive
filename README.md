
This is an example application of [rhizome][rhizome], a web server for  participative performances and installations. 

Basically, participants can use their mobile device to visit the rhizome page, and we use javascript to detect Gyroscope data (modern browsers please), send OSC command to [SuperCollider](http://supercollider.github.io) through [rhizome][rhizome], changing the audio and visuals.

[rhizome]: https://github.com/sebpiq/rhizome

## Setup

1. Simpley run `npm install -g rhizome` to install rhizome, for infomation on the [github repo](https://github.com/sebpiq/rhizome)

2. Install all the bower components use `bower install` (`npm install -g bower` to install bower)

3. Take a look at the supercollider [file](scfile), evaluating some code.

4. `rhizome config.js` to open the server, visit `localhost:8000`

[scfile]: https://github.com/kunjinkao/interactive/blob/master/interactive.scd


