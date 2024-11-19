#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.


app = window.App ||= {}

app.GroupParticipations = {
  load_music_levels: (e) ->
    elem = $(e.target)
    music_style = elem.val()
    # console.log(music_style)
    options = $("." + music_style).html()
    # console.log(options)
    $('#event_group_participation_music_level').html(options)
}

$(document).on('change', '#event_group_participation_music_type', app.GroupParticipations.load_music_levels)
