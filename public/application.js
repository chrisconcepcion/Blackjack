$(document).ready(function() {
	#("form#hit input").click(Function(){
		alert("You clicked");
		$.ajax({
			type: "POST"
			url: "/game"
		})

	})
})

$(document).ready(function() {
	#("form#stay input").click(Function(){
		alert("You clicked");
		$.ajax({
			type: "POST"
			url: "/stay"
		})

	})
})


$(document).ready(function() {
	#("form#playagain input").click(Function(){
		alert("You clicked");
		$.ajax({
			type: "GET"
			url: "/bet"
		})

	})
})