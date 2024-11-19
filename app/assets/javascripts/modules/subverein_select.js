//  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
//  hitobito_ejv and licensed under the Affero General Public License version 3
//  or later. See the COPYING file at the top-level directory or at
//  https://github.com/hitobito/hitobito_ejv.

var app;

app = window.App || (window.App = {});

app.SubvereinSelect = {
  select_all: function(e) {
    var checked, table;
    checked = e.target.checked;
    table = $(e.target).closest('.checkboxes');
    return table.find('input[type="checkbox"]:not([disabled])').prop('checked', checked);
  }
};

$(document).on('click', '#subgroup-select .checkboxes input#all', app.SubvereinSelect.select_all);
