// the host of processing machine
n = NetAddr("192.168.1.101", 12000);

(
~grain_bus = Bus.audio(s);

// load all the buffers
~buffers = "~/Desktop/mixture/sounds/grains/*".asAbsolutePath.pathMatch.collect {|file| Buffer.read(s, file);};

// id -> nodeId in scsynth, 
~userNodeDict = ();
)



(
SynthDef(\Grainbuf, { |out=0, buf, dens=0.5, pan=0.5, dur=0.5, rate=0.5, pos=0.5, amp=0.5|
  var trig = Dust.kr(dens.linlin(0, 1, 5, 15));
  var sound = GrainBuf.ar(
    numChannels: 2,
    trigger: trig,
    dur: dur.linlin(0, 1, 0.02, 0.08),
    sndbuf: buf,
    rate: rate.linlin(0, 1, 0.5, 1.5),
    pos: pos,
    interp: 2,
    pan: pan.linlin(0, 1, -1, 1),
    envbufnum: -1
  ) * 1 * (amp.linlin(0, 1, 0.5, 1)) * 0.25;
  Out.ar(out, sound);
}).add;

//limit the grains volume
Ndef(\limit, {
  var bus = ~grain_bus;
  var sound = Limiter.ar(In.ar(bus, 2), 1.0);
  sound;
}).play(0, 2, addAction: \addToTail);

(
// new device connect
OSCdef(\new_audio, { |args|
  var userID = args[1];
  var nodeID = s.nextNodeID;

  "new audio".postln;

  if(~userNodeDict.at(userID) != nil, {
    s.sendMsg(\n_free, ~userNodeDict.at(userID));
  });

  ~userNodeDict.add(userID -> nodeID);
  ~userNodeDict.postln;

  s.sendMsg(\s_new, \Grainbuf, nodeID, 0, 0, \buf, ~buffers.choose.bufnum, \out, ~grain_bus);

}, '/interactive/new_audio', nil, 9001);


OSCdef(\new_visual, { |args|
  var userID = args[1];

  "new visual".postln;

  if(~userNodeDict.at(userID) != nil, {
    s.sendMsg(\n_free, ~userNodeDict.at(userID));
  });

  n.sendMsg("/new");

}, '/interactive/new_visual', nil, 9001);

// update the parameter
OSCdef(\update_audio, { |args|
  var userID = args[1];
  var xval = args[2].abs.linlin(0, 8, 0.0, 1.0);
  var yval = args[3].abs.linlin(0, 8, 0.0, 1.0);
  var zval = args[4].abs.linlin(0, 8, 0.0, 1.0);
  var alpha = args[5].linlin(0, 360, 0.0, 1.0);
  var beta = args[6].linlin(-180, 180, 0.0, 1.0);
  var gamma = args[7].linlin(-90, 90, 0.0, 1.0);

  var nodeID = ~userNodeDict.at(userID);

  var log = "update "++ userID ++ "node " ++ nodeID ++ "args " ++ args;
  log.postln;

  s.sendMsg(\n_set, nodeID,
    \dens, yval,
    \pan, alpha,
    \dur, gamma,
    \rate, zval,
    \pos, beta,
    \amp, xval
  );


  n.sendMsg("/update", xval, yval, zval, alpha, beta, gamma);

}, '/interactive/update_audio', nil, 9001);


OSCdef(\update_visual, { |args|
  var userID = args[1];
  var xval = args[2].abs.linlin(0, 8, 0.5, 1.0);
  var yval = args[3].abs.linlin(0, 8, 0.0, 1.0);
  var zval = args[4].abs.linlin(0, 8, 0.0, 1.0);
  var alpha = args[5].linlin(0, 360, 0.0, 1.0);
  var beta = args[6].linlin(-180, 180, 0.0, 1.0);
  var gamma = args[7].linlin(-90, 90, 0.0, 1.0);
  args.postln;

  n.sendMsg("/update", xval, yval, zval, alpha, beta, gamma);

}, '/interactive/update_visual', nil, 9001);


OSCdef(\change, { |args|
  var userID = args[1];
  var nodeID = ~userNodeDict.at(userID);

  // var log = "change buffer: "++ userID ++ " node " ++ nodeID ++ "args " ++ args;
  // log.postln;

  s.sendMsg(\n_set, nodeID,
    \buf, ~buffers.choose.bufnum
  );

}, '/interactive/change', nil, 9001);

OSCdef(\subscribed, { |args|
  "subed".postln;
}, '/sys/subscribed', nil, 9001);


// NOTICE: /sys/close is my patch to rhizome, currently not in the npm version
OSCdef(\close, { |args|

  var userID = args[1];
  var nodeID = ~userNodeDict.at(userID);
  ~userNodeDict.removeAt(nodeID);

  s.sendMsg(\n_free, nodeID);

}, '/sys/close', nil, 9001);

)


(
var addr = NetAddr.new("127.0.0.1", 9000);
OSCdef.all.do {|item|
  addr.sendMsg('/sys/subscribe', 9001, item.path.asString);
};
// pause the processing sktech, display help text for audience
n.sendMsg("/pause");
)


// resume the sktech
n.sendMsg("/resume");