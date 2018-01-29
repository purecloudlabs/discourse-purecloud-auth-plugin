
(function(){
	$(document).ready(function() {
		$('body').on('DOMNodeInserted', '#discourse-modal', function() {
			//setTimeout(function(){$('#discourse-modal').removeClass('hidden');}, 800);
		});
	});
})();
