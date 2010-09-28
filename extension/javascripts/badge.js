$(document).ready(function(){	
	chrome.tabs.getSelected(null, function(tab) {
      chrome.extension.sendRequest({'action' : 'shortenUrl', 'data' : tab.url}, setShortUrl);
    });
});

function setShortUrl(short_url) {
	$('#short_url').html(short_url);
}