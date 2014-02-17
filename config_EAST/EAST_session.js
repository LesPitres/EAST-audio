/*global EVENTS */
/*jshint devel: true */
/*jshint nonstandard: true */

(function(){

// public API
document.SESSION = {
  record: function() {},  // starts session recording
  play: function() {},    // starts playing of loaded session
  pause: function() {},   // suspends/resume playing
  jump: function(secs) {},// jumps at specified time
  load: function(str) {}, // loads session from string XML
  save: function() {}     // returns session as string XML
};

var sessionEvents = [],           // session events list
    sessionLastEventTime = null,  // absolute time of last event
    sessionIsRecording = false,   // are we recording or playing a session ?
    sessionIsPaused = false,      // was the session playback suspended ?
    slideControlContainer = null, // "master" timeContainer for slide changing and current slide index
    id_cpt = 100;                 // counter for our id generator

// adds an event to the session events list
var pushEvent = function(event, id){
  var eventTime = (new Date()).getTime(),
      interval = eventTime - sessionLastEventTime;

  sessionLastEventTime = eventTime;

  // do not catch show or reset events happening after slide events
  // also do not catch too close events, except show following reset
  if ((sessionEvents[sessionEvents.length-1].type !== 'slide' ||
      (event !== 'show' && event !== 'reset')) && ((interval>50) ||
      (event === 'show' && sessionEvents[sessionEvents.length-1].type ===
      'reset'))) {
    sessionEvents.push({
      type: event,
      id: id,
      time: interval
    });
  }
};

// Adds an id to title elements if necessary and returns it
var checkID = function(node){
  if (!node.hasAttribute('id')) {
    node.id = 'el'+(id_cpt+=1);
  }
  return node.id;
};

// Converts session events array to XML
var sessionEventsToXml = function(){
  var doc = document.implementation.createDocument("", "", null);
  doc.appendChild(doc.createComment("SMIL session file"));
  doc.appendChild(doc.createComment("Save this to a .xml file."));
  doc.appendChild(doc.createComment("To play back, open your presentation, click \"Load session\" button and select this file."));
  doc.appendChild(doc.createElement('xml'));
  doc.lastChild.appendChild(doc.createTextNode('\n'));
  for (var _e=0; _e<sessionEvents.length; _e+=1) {
    var e = doc.createElement('event');
    e.setAttribute('type', sessionEvents[_e].type);
    e.setAttribute('time', sessionEvents[_e].time);
    if (sessionEvents[_e].id !== undefined) {
      e.setAttribute('id', sessionEvents[_e].id);
    }
    doc.lastChild.appendChild(e);
    doc.lastChild.appendChild(doc.createTextNode('\n'));
  }
  return (new XMLSerializer()).serializeToString(doc);
};

// Reads XML string and convert it to a session events array
var xmlToSessionEvents = function(xml){
  var doc = (new DOMParser()).parseFromString(xml, "application/xml"),
      events = doc.getElementsByTagName('event'),
      session = [];

  for (var _e=0; _e<events.length; _e+=1) {
    session.push({
      type: events[_e].getAttribute('type'),
      id: events[_e].getAttribute('id'),
      time: parseInt(events[_e].getAttribute('time'), 10)
    });
  }
  return session;
};

// variables and functions for session playback
var playback = {
  _position: 0,
  _lastTimeout: null,

  play: function(){
    if (!sessionIsRecording){
      window.clearTimeout(playback._lastTimeout);
    }
    playback._position = 0;
    playback._lastTimeout = null;
    sessionIsRecording = false;
    sessionIsPaused = false;
    playback.walk();
  },

  walk: function(onlyOne){
    if (playback._position < sessionEvents.length && !onlyOne &&
        sessionEvents[playback._position+1]){
      sessionLastEventTime = (new Date()).getTime();
      playback._lastTimeout = window.setTimeout(playback.walk,
                                      sessionEvents[playback._position+1].time);
    }

    switch (sessionEvents[playback._position].type){
      case 'slide':
        slideControlContainer.selectIndex(
          parseInt(sessionEvents[playback._position].id, 10)
        );
        break;
      case 'reset':
        document.getTimeContainersByTarget(
          document.getElementById(window.location.hash.slice(1))
        )[0].reset();
        break;
      case 'show':
        document.getTimeContainersByTarget(
          document.getElementById(window.location.hash.slice(1))
        )[0].show();
        break;
      case 'click':
        document.getElementById(window.location.hash.slice(1)).click();
        break;
      case 'li':
        document.getElementById(sessionEvents[playback._position].id).click();
        break;
      default:
        console.error("EAST-session: unknown event type " +
                      sessionEvents[playback._position].type);
    }

    playback._position += 1;
  },

  pause: function(){
    window.clearTimeout(playback._lastTimeout);
    sessionLastEventTime = (new Date()).getTime() - sessionLastEventTime;
    sessionIsPaused = true;
  },

  resume: function(){
    playback._lastTimeout = window.setTimeout(playback.walk,
                sessionEvents[playback._position].time - sessionLastEventTime);
    sessionIsPaused = false;
  },

  jump: function(time){
    var timeCounter = 0,
        jumpFrom = 0,
        jumpTo = 0,
        nearestSlideIndex = 0;

    while (jumpTo<sessionEvents.length &&
           timeCounter+sessionEvents[jumpTo].time < time){
      if (sessionEvents[jumpTo].type === 'slide'){
        nearestSlideIndex = jumpTo;
      }
      timeCounter += sessionEvents[jumpTo].time;
      jumpTo += 1;
    }

    if (jumpTo === playback._position){
      return;
    } else {
      jumpFrom = nearestSlideIndex;
    }

    window.clearTimeout(playback._lastTimeout);
    for (var _i=jumpFrom; _i<jumpTo; _i+=1){
      playback._position = _i;
      playback.walk(true);
    }
    sessionLastEventTime = time - timeCounter +
      sessionEvents[playback._position].time;
    if(!sessionIsPaused){
      playback.resume();
    }
 }
};

// Public API
document.SESSION.record = function(){
 VIDEO_RECORD();
 sessionEvents = [{
    type: 'slide',
    id: slideControlContainer.currentIndex,
    time: 0
  }];
  sessionLastEventTime = (new Date()).getTime();
  sessionIsRecording = true;
};

document.SESSION.play = function(){
  if (!sessionIsPaused){
    document.SESSION.pause();
  }
  playback.play();
};

document.SESSION.pause = function(){
  if(sessionIsPaused){
    playback.resume();
  } else {
    playback.pause();
  }
};

document.SESSION.jump = function(time){
  playback.jump(time);
};

document.SESSION.load = function(str){
  var events = xmlToSessionEvents(str);
  if (events.length && events.length>0){
    sessionEvents = events;
    return true;
  }
  return false;
};

document.SESSION.save = function(){
  return unescape(encodeURIComponent(sessionEventsToXml()));
};

// Catchers for session events
var eventCatchers = {
  /*jshint curly: false */
  selectIndex: function(slide_id){
    if (sessionIsRecording) pushEvent('slide', slide_id);
    return this.org_selectIndex.apply(this, arguments);
  },
  reset: function(){
    if (sessionIsRecording) pushEvent('reset');
    return this.org_reset.apply(this, arguments);
  },
  show: function(){
    if (sessionIsRecording) pushEvent('show');
    return this.org_show.apply(this, arguments);
  },
  slide_click: function(e){
    if (sessionIsRecording) pushEvent('click');
  },
  li_click: function(id, e){
    if (sessionIsRecording) pushEvent('li', id);
  }
};

// Init, binds to events and creates UI
EVENTS.onSMILReady(function() {
  var containers = document.getTimeContainersByTagName("*");
  slideControlContainer = containers[containers.length-1];

  for (var _i=0; _i<containers.length; _i+=1) {
    var navigation = containers[_i].parseAttribute("navigation");
    if (navigation) {
      // overrides selectIndex for each slide
      containers[_i].org_selectIndex = containers[_i].selectIndex;
      containers[_i].selectIndex = eventCatchers.selectIndex;

      for (var _j=0; _j<containers[_i].timeNodes.length; _j+=1) {
        var slide = containers[_i].timeNodes[_j];
        // overrides slide.reset()
        slide.org_reset = slide.reset;
        slide.reset = eventCatchers.reset;
        // overrides slide.show()
        slide.org_show = slide.show;
        slide.show = eventCatchers.show;
        // intercepts slide click
        EVENTS.bind(slide.target, "click", eventCatchers.slide_click);
      }
    }
  }

  // intercepts clicks on lists
  var liTab = document.getElementsByTagName("li");
  for (_i=0; _i<liTab.length; _i+=1) {
    if (liTab[_i].hasAttribute("smil")){
      liTab[_i].addEventListener(
        "click", eventCatchers.li_click.bind(null, checkID(liTab[_i]))
      );
    }
  }
  
  // add buttons in navbar
  var recbtn = document.createElement('button'),
      exportbtn = document.createElement('button'),
      fileInput = document.createElement('input');

  recbtn.setAttribute('id', 'session_rec');
  recbtn.title = 'Start session recording';
  recbtn.appendChild(document.createTextNode('Record session'));

  exportbtn.id = 'session_export'; exportbtn.title = 'Export session';
  exportbtn.appendChild(document.createTextNode('Export session'));

  fileInput.type = 'file'; fileInput.id = 'session_import';
  fileInput.title = 'Import session';

  recbtn.addEventListener('click', document.SESSION.record);
  exportbtn.addEventListener('click', function(){
    window.open('data:text/xml;base64,' +
                    window.btoa(unescape(
                      encodeURIComponent(sessionEventsToXml())
                    )));
  });
  fileInput.addEventListener('change', function(e){
    var file = e.target.files[0];
    var reader = new FileReader();
    reader.onload = function(f){
      sessionEvents = xmlToSessionEvents(f.target.result);
 	  VIDEO_PLAYBACK(f.target.result);
	  playback.play();
    };
    reader.readAsText(file);
  });

  document.getElementById('navigation_par').appendChild(recbtn);
  document.getElementById('navigation_par').appendChild(exportbtn);
  document.getElementById('navigation_par').appendChild(fileInput);

  document.SESSION.record();
});

}());
