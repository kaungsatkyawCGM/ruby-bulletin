$(document).ready(function() {
	$("#userImportExcel").change(function() {
		let file = $(this).prop('files')[0];
		console.log(file);
        if (!(checkFileValidation(file))) {
            return false;
        }
		showLoading(5000);
		
		$('#importForm').submit();
	})
});

function checkFileValidation(file) {
    var acceptMimeTypes = [
        "text/csv"
    ];
    console.log(file.type);
    if (!acceptMimeTypes.includes(file.type)) {
        $('.import-error')
            .text("Wrong file type!");
        return false;
    }

    return true;
}

function showLoading(timeout) {
  var id = '_loading_';
  $('body').append($('<div/>', {
    style: "position: fixed;width: 100%;height: 100%;text-align: center;display: flex;left: 0;justify-content: center;right: 0;" +
    "bottom: 0;align-items: center;background: rgb(0 0 0 / 7%) url(assets/loading.gif) 50% 50% no-repeat;z-index: 3000;text-align: center;",
    class: '__loading_screen',
    id: id
  }));

  setTimeout(function() {
    timeout ? $("#" + id).remove() : '';
  }, timeout ? timeout : 0);
}