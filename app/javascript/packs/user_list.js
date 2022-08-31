var table = $('#example').DataTable({
	columnDefs: [
		{ orderable: false, targets: 4 }
	],
});

table.on('click', 'td', function() {
	var cell = table.cell(this).index();
	if (cell.column != 4) {
		var detailUrl = $(this).parent().data('info-url');
		location.href=detailUrl;
	} else {
		$(".delete-user-btn").attr("href", $(this).data("delete-url"));
		$("#deleteModal").modal('show');
	}
});