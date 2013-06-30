$(document).ready(function() {
	player_hits();
	player_stays();
});


function player_hits() {
	$(document).on("click", "form#hit input", function() {
		$.ajax({
			type: "POST",
			url: "/game"
		}).done(function(msg){
			$("#game").replaceWith(msg)
		});
		return false;
	});
}


function player_stays() {
	$(document).on("click", "form#stay input", function() {
		$.ajax({
			type: "POST",
			url: "/stay"
		}).done(function(msg){
			$("#game").replaceWith(msg)
		});
		return false;
	});
}


