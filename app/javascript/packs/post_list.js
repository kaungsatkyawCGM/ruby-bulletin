var imageWidth = $('.post-image').width();
var halfWidth = imageWidth / 2;
$('.post-image').css({'height':halfWidth+'px'});

$('#image_input').change(function() {
	var destOrignalFile = this.value;
    var allowedExtensions = /(\.jpg|\.jpeg|\.png|\.gif)$/i;
    if(!allowedExtensions.exec(destOrignalFile)){
        alert('Please you can upload file having extensions .jpeg/.jpg/.png/.gif only.');
        this.value = '';
        return false;
    }

    var fileImage = $(this).prop("files")[0];
	reader = new FileReader();
	reader.onload = function(e) {
		$('#image_displayer').attr('src', e.target.result);
		document.getElementById("imageData").value = e.target.result;
	};
	$('.post-image').removeClass('post-image d-none').addClass('post-image');
	var imageWidth = $('.post-image').width();
	var halfWidth = imageWidth / 2;
	$('.post-image').css({'height':halfWidth+'px'});
	reader.readAsDataURL(fileImage);
});

$("#btn-clear").click(function() {
	$("#imageData").val("");
	$('#image_displayer').attr('src', '');
	$("#image_input").val("");
	$('.post-image').removeClass('post-image').addClass('post-image d-none');
	$("#description-input").val("");
	$("#title-input").val("");
});

$(".clear-image-btn").click(function() {
	$("#clear").val("true");
	$('#image_displayer').attr('src', '');
	$("#image_input").val("");
	$('.post-image').removeClass('post-image').addClass('post-image d-none');
});

