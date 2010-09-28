$(document).ready(function(){	
	chrome.extension.sendRequest({'action' : 'shortenUrl'}, setShortUrl);
});

function setShortUrl(short_url) {
	$('#short_url').html(short_url);
}