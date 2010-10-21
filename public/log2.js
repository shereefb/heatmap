
var ytplayer;
var D=[];
var last = 0;
var current = 0;
var truelast = 0;
var lognext = false;
var threshold = 2; //seconds above wich we log
var reported = true; 

window.onbeforeunload = unload;
// function importScript(url){
//     var tag = document.createElement("script");
//     tag.type="text/javascript";
//     tag.src = url;
//     document.body.appendChild(tag);
// }
// 
// importScript("//www.google.com/jsapi?key=ABQIAAAApLEIHfur721vAJ-APsc9lhTfHqCIbgNWv_79H_rHxL-OusGewhTXA77vlFa5acmSlBXKMptYULfq6w"); // example

// google.load("swfobject", "2.1");
/*
 * Polling the player for information
 */

// Update a particular HTML element with a new value
function updateHTML(elmId, value) {
  document.getElementById(elmId).innerHTML = value;
}

// This function is called when an error is thrown by the player
function onPlayerError(errorCode) {
  alert("An error occured of type:" + errorCode);
}

// This function is called when the player changes state
function onPlayerStateChange(newState) {
	
	//todo: checkout buffering (3)
	
	lognext = false;

	//paused
	if(newState == 2){
		truelast = last;
		if (ytplayer.getDuration() - ytplayer.getCurrentTime() < 2){
			report(true);
		}
		
	}
	
	//started
	if(newState == 1){
		lognext = true;
		reported = false; //now we report
	}
	
	//started
	if(newState == 0){
		report(true);
	}
	
	if(ytplayer && ytplayer.getDuration) {
	updateHTML("playerState", newState);
    updateHTML("videoDuration", ytplayer.getDuration());
    updateHTML("videoCurrentTime", ytplayer.getCurrentTime());
    updateHTML("bytesTotal", ytplayer.getVideoBytesTotal());
    updateHTML("startBytes", ytplayer.getVideoStartBytes());
    updateHTML("bytesLoaded", ytplayer.getVideoBytesLoaded());
  }
  
	
}

// Display information about the current state of the player
function updatePlayerInfo() {
	
	if ((truelast - last) > threshold || (last - truelast) > threshold){
		console.log("current " + last + "  last " + truelast);
		D.push([Math.round(truelast),Math.round(last)]);
	}
	
	
}

function updateLast(){
	last = ytplayer.getCurrentTime();
	
	if (lognext == true){
		updatePlayerInfo();
		lognext = false;
	}	
}

// This function is automatically called by the player once it loads
function onYouTubePlayerReady(playerId) {
  ytplayer = document.getElementById("e1");
  // This causes the updatePlayerInfo function to be called every 250ms to
  // get fresh data from the player
  setInterval(updateLast, 250);
  updatePlayerInfo();
  ytplayer.addEventListener("onStateChange", "onPlayerStateChange");
  ytplayer.addEventListener("onError", "onPlayerError");
}

function unload(){
	report(false);
}

// Sends data to server
function report(sync){
	console.log("reporting");
	if (reported == true){
		console.log("reported is true, so we're not going to report");
		return;
	}
	reported = true;
	
	var url = "http://localhost:3000/logs/create";
	var params = "youtube_id=" + _vhmid;
	params = params + "&timelog=" + D.join("-");
	var http = new XMLHttpRequest();
	http.open("POST", url, sync);

	//Send the proper header information along with the request
	http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	http.setRequestHeader("Content-length", params.length);
	http.setRequestHeader("Connection", "close");
	// http.onreadystatechange = function() {//Call a function when the state changes.
	// 	if(http.readyState == 4 && http.status == 200) {
	// 		alert(http.responseText);
	// 	}
	// }
	http.send(params);
	
}

// // The "main method" of this sample. Called when someone clicks "Run".
// function loadPlayer() {
//   // The video to load
//   var videoID = _vhmid;
//   // Lets Flash from another domain call JavaScript
//   var params = { allowScriptAccess: "always" };
//   // The element id of the Flash embed
//   var atts = { id: "ytPlayer" };
//   // All of the magic handled by SWFObject (http://code.google.com/p/swfobject/)
//   swfobject.embedSWF("http://www.youtube.com/v/" + videoID +
//                      "&enablejsapi=1&playerapiid=player1",
//                      "videoDiv", "480", "295", "8", null, null, params, atts);
// }
// function _run() {
//   loadPlayer();
// }
// google.setOnLoadCallback(_run);
