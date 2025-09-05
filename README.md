# Hitobito Eidgenössischer Jodlerverband

This hitobito wagon defines the organization hierarchy with groups and roles
of the Eidgenössischer Jodlerverband.

<!-- roles:start -->
    * Dachverband
      * Dachverband
        * Administrator: [:layer_and_below_full, :admin, :impersonation, :finance, :song_census]
        * Verantwortlicher SUISA: [:group_read, :song_census]
      * Zentralsekretariat
        * Administrator: [:layer_and_below_full, :finance, :impersonation]
        * Sekretär: [:layer_and_below_full, :finance]
        * Hilfe: [:layer_and_below_read]
      * Zentralvorstand
        * Präsident: [:layer_full, :layer_and_below_read]
        * Mitglied: [:layer_and_below_read]
      * Delegierte
        * Mitglied: [:group_read]
      * Fachkommission
        * Präsident: [:group_and_below_full]
        * Mitglied: [:group_read]
    * Unterverband < Dachverband
      * Unterverband
        * Administrator: [:layer_and_below_full]
        * Verantwortlicher SUISA: [:group_read, :song_census]
      * Vorstand
        * Präsident: [:layer_full, :layer_and_below_read]
        * Vizepräsident: [:layer_and_below_read]
        * Kassier: [:layer_and_below_read, :finance]
        * Mitgliederverwalter: [:layer_and_below_read]
        * Sekretär: [:group_full, :layer_and_below_read]
        * Mitglied: [:layer_and_below_read]
      * Einzelmitglieder
        * Jodler: []
        * Alphornbläser: []
        * Fahnenschwinger: []
        * Freund & Gönner: []
        * Ehrenmitglied: []
        * Freimitglied: []
      * Vereinigung
        * Präsident: [:group_and_below_full]
        * Mitglied: []
    * Gruppe < Unterverband, Dachverband
      * Gruppe
        * Administrator: [:layer_and_below_full]
        * ChorleiterIn: []
        * Verantwortlicher SUISA: [:group_read, :song_census]
        * Mitglied: [:group_read]
        * Präsident: [:layer_full, :layer_and_below_read]
        * Kassier: [:layer_and_below_read, :finance]

(Output of rake app:hitobito:roles)
<!-- roles:end -->

## Glossar

| interner Name             | Domänenbegriff   |
| --------------            | --------------   |
| Concert                   | Aufführung       |
| Song                      | Werk             |
| SongCensus                | Meldeliste       |
| SongCount                 | Werkmeldung      |

## Ablauf SUISA-Meldung

- die Vereine erfassen über den Meldezeitraum hinweg ihre Aufführungen.
- jeder Aufführung werden die gespielten Werke in entsprechender Anzahl zugeordnet.
- mit dem Button "Meldeliste einreichen" werden die Aufführungen der aktuellen Meldeliste zugeordnet und gelten damit als eingereicht.
- Sonderfälle
  - wenn man keine Aufführungen während der Meldeperiode hatte, kann eine alternative Erledigungsart gewählt werden. Diese legt eine spezielle Aufführung an, die dann wie sonst auch als Meldeliste eingereicht werden kann.
  - wenn eine neue Aufführung erfasst wird, werden diese speziellen Aufführungen für das aktuelle Jahr wieder gelöscht.
  - wenn eine neue Aufführung nach dem Einreichen der Meldeliste erfasst wird, kann man erneut die Meldeliste einreichen. Das Kriterium ist "gibt es noch Aufführungen, die nicht der aktuellen Meldeliste zugeordnet sind".

## Manuelles Erfassen der Mitgliederanzahl

| Rake Task                                             | Erklärung                                                                                       |
| ---------                                             | ---------                                                                                       |
| `group:manually_counted_members:activate[group_id]`   | Setzt auf self und allen Subgruppen manually_counted_members auf `true`. Betrifft nur Vereine.  |
| `group:manually_counted_members:deactivate[group_id]` | Setzt auf self und allen Subgruppen manually_counted_members auf `false`. Betrifft nur Vereine. |

Sobald manually_counted_members auf true gesetzt ist, kann die Mitgliederanzahl im groups#edit bearbeitet werden.