$(function() {
  // constant
  AUDIO = 1;
  VISUAL = 2;

  $visualSection = $('#visual');
  $audioSection = $('#audio');

  var dispatch = function(userId){
    if(userId % 3 === 1) {
      return VISUAL;
    } else {
      return AUDIO;
    }
  };

  var newAudio = function(userId){
    console.log('new audio');
    rhizome.message('/interactive/new_audio', [userId]);
    $visualSection.hide();
    $audioSection.show();
  };

  var newVisual = function(userId){
    console.log('new visual');
    rhizome.message('/interactive/new_visual', [userId]);
    $audioSection.hide();
    $visualSection.show();
  };


  // `rhizome.start` is the first function that should be called. It opens the connection, and gets a user id.
  // The function inside is executed once the connection has been established properly.
  rhizome.start(function(err) {

    if (err) return alert(err)

    var userId = rhizome.userId;

    var type = dispatch(userId);

    // init, new synth for audio
    if(type===AUDIO) {
      newAudio(userId);
    } else if(type===VISUAL) {
      newVisual(userId);
    }

    gyro.frequency = 200;

    gyro.startTracking(function(o) {
      var args = [userId, o.x, o.y, o.z, o.alpha, o.beta, o.gamma];
      if(type===AUDIO) {
        rhizome.message('/interactive/update_audio', args);
      } else if(type===VISUAL) {
        rhizome.message('/interactive/update_visual', args);
      }

    });

    $('#changeSoundBtn').on('click', function(){
      var args = [userId];
      rhizome.message('/interactive/change', args);
    });

  })

})
