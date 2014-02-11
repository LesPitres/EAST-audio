(function(){

var videoEvents = [],           // session events list
    videoLastEventTime = null,  // absolute time of last event
    sessionIsRecording = false,   // are we recording or playing a session ?
	seek = false;
	
// save an event		
var pushEvent = function(event, id_video){
	var eventTime = (new Date()).getTime(),
      interval = eventTime - videoLastEventTime;
	
	var current = document.getElementsByTagName("video")[id_video].currentTime;
	
	videoLastEventTime = eventTime;
	
	//for seeked when video is playing, 3 events : pause, seeked and play
	// only keep seek in videoEvents
	
	if(videoEvents.length > 1){
		// when pause, seek and play or play, pause and seek
		if (event === 'video_seek' && videoEvents[videoEvents.length-1].type === 'video_pause' && 
			current == videoEvents[videoEvents.length-1].current_time && 
			id_video == videoEvents[videoEvents.length-1].id_video ) {
			
			// if play pause seek, pop play and pause
			if (videoEvents[videoEvents.length-2].type === 'video_play' && 
				current == videoEvents[videoEvents.length-2].current_time && 
				id_video == videoEvents[videoEvents.length-2].id_video ) {
				
				videoEvents.pop();
				videoEvents.pop();
				
			}else{ // if pause seek play, only pop pause
				
				videoEvents.pop();
				seek = true;	
			}
			
		// when pause, play and seek
		} else if(event === 'video_seek' && videoEvents[videoEvents.length-2].type === 'video_pause' && 
			current == videoEvents[videoEvents.length-2].current_time && 
			id_video == videoEvents[videoEvents.length-2].id_video){
			
			videoEvents.pop();
			videoEvents.pop();
		}
	}
	if(event === 'video_play' && seek == true){
		seek = false;
	}else{
		videoEvents.push({
			type: event,
			id_video: id_video,
			time: interval,
			current_time: current
		});
	}
}	

//transform video event to XML 
var sessionAudioToXml = function(){
	//recover session events from EAST-session
	var sess = document.SESSION.save();
	var doc = (new DOMParser()).parseFromString(decodeURIComponent(sess), "application/xml");
	
	//add video events to the XML
	doc.lastChild.appendChild(doc.createTextNode('\n'));
	doc.lastChild.appendChild(doc.createComment('For video'));
	
	var videos = document.getElementsByTagName("video");
	
	doc.lastChild.appendChild(doc.createTextNode('\n'));
	
	for (var _e=0; _e<videoEvents.length; _e+=1) {
		var e = doc.createElement('video_event');
		e.setAttribute('type', videoEvents[_e].type);
		e.setAttribute('time', videoEvents[_e].time);
		e.setAttribute('id_video', videoEvents[_e].id_video);
		if(videoEvents[_e].type === 'video_seek')
			e.setAttribute('current_time', videoEvents[_e].current_time);
		
		doc.lastChild.appendChild(e);
		doc.lastChild.appendChild(doc.createTextNode('\n'));
	}
	
	var page = unescape(encodeURIComponent((new XMLSerializer()).serializeToString(doc)));
	window.open('data:text/xml;base64,' +
                    window.btoa(page)
				);
}	
				
var eventCatchers = {
  video_seek: function(id_video){
	if (sessionIsRecording) pushEvent('video_seek', id_video);
  },
  video_play: function(id_video){
	if (sessionIsRecording) pushEvent('video_play', id_video);
  },
  video_pause: function(id_video){
	if (sessionIsRecording) pushEvent('video_pause', id_video);
  }	
 };

 
VIDEO_RECORD = function(){
  videoLastEventTime = (new Date()).getTime();
  sessionIsRecording = true;
  videoEvents = [];
  
  var videos = document.getElementsByTagName("video");
  for (var nb_i = 0; nb_i < videos.length; nb_i++){
	//save current time at the beginning of videos
	pushEvent('video_seek', nb_i);
	if(!videos[nb_i].paused && videos[nb_i].currentTime != 0)
		pushEvent('video_play', nb_i);
	}
}


EVENTS.onSMILReady(function() { 
  //intercepts events for video
  var videos = document.getElementsByTagName("video");
  for (var nb_i = 0; nb_i < videos.length; nb_i++){
	videos[nb_i].addEventListener("seeked", eventCatchers.video_seek.bind(null, nb_i));
	videos[nb_i].addEventListener("play", eventCatchers.video_play.bind(null, nb_i));
	videos[nb_i].addEventListener("pause", eventCatchers.video_pause.bind(null, nb_i));
  }

  // add button in navbar
  var cc = document.createElement('button');

  cc.setAttribute('id', 'session_rec');
  cc.title = 'Export session with audio';
  cc.appendChild(document.createTextNode('Export session with audio'));

  cc.addEventListener('click', sessionAudioToXml);

  document.getElementById('navigation_par').appendChild(cc);
});

}());