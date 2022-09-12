var table = $('#example').DataTable({
	columnDefs: [
		{ orderable: false, targets: 4 }
	],
});
// function map_datatable_columns(coldef, options) {
//     options = options ? options : {};

//     function htmlEscapeEntities(d) {
//         return d.replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
//     }

//     function toString(data) {
//         return data ? data.toString() : '';
//     }

//     return coldef.map(function(e, i) {
//         var col = e.data ? e : {
//             data: e
//         };
//         col.targets = i;
//         col.defaultContent = "";
//         if (options.disabled_cols) {
//             col.searchable = options.disabled_cols.indexOf(i) < 0;
//             col.orderable = options.disabled_cols.indexOf(i) < 0;
//         }
//         if (options.hidden_cols) {
//             col.visible = options.hidden_cols.indexOf(i) < 0;
//         }

//         if ((!col.render) && (typeof col.data === 'string')) {
//             col.render = function(data, type) {
//                 return type === 'display' ? htmlEscapeEntities(toString(data)) : data;
//             }
//         }
//         return col;
//     });
// }

// var coldef = [
//     'name',
//     'email',
//     'phone',
//     {
//         data: 'role',
//         render: function(data, type, full, meta) {
//             if (full.role == 1) {
//                 return "Admin";
//             }
//             return 'User';
//         }
//     },
//     function(row, type, val, meta) {
//         return '<button class="primary-button btn post bg-danger' +
//             'data-bs-toggle="modal" data-bs-target="#deleteModal' + row.id + '" >' +
//             '<i class="fa-solid fa-trash"></i>' +
//             '</button>';
//     },
// ];

// var table = $('#example').on('preXhr.dt', function(e, settings, data) {}).DataTable({
//     processing: true,
//     serverSide: true,
//     deferRender: true,
//     columnDefs: map_datatable_columns(coldef, {
//         disabled_cols: [4]
//     }),
//     columns: [
//         null,
//         null,
//         null,
//         null,
//         null,
//     ],
//     ajax: {
//         url: 'users/list',
//         method: "post",
//         data: { authenticity_token: $('[name="csrf-token"]')[0].content},
//         dataSrc: function(json) {
//             return json.users;
//         }
//     },
// });

table.on('click', 'td', function() {
    var cell = table.cell(this).index();
    if (cell.column != 4) {
        var detailUrl = $(this).parent().data('info-url');
        location.href = detailUrl;
    } else {
        $("#deleteModal").modal('show');
    }
});