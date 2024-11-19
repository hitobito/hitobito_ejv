# Hitobito Eidgenössischer Jodlerverband

This hitobito wagon defines the organization hierarchy with groups and roles
of the Eidgenössischer Jodlerverband.

<!-- roles:start -->
    * Dachverband
      * Dachverband
        * Administrator: [:layer_and_below_full, :admin, :impersonation, :finance, :song_census, :uv_lohnsumme]
        * Verantwortlicher SUISA: [:group_read, :song_census]
      * Geschäftsstelle
        * Geschäftsführung: [:layer_and_below_full, :impersonation]
        * Mitarbeiter: [:layer_and_below_full, :approve_applications, :finance]
        * Hilfe: [:layer_and_below_read]
      * Verbandsleitung
        * Präsident: [:layer_full, :layer_and_below_read]
        * Vizepräsident: [:layer_and_below_read]
        * Finanzchef: [:layer_and_below_read, :finance]
        * Veteranenchef: [:layer_and_below_read]
        * Mitglied: [:layer_and_below_read]
      * Musikkommission
        * Präsident: [:layer_read, :group_and_below_full]
        * Mitglied: [:layer_read]
      * Arbeitsgruppe
        * Leitung: [:layer_read]
        * Mitglied: [:group_and_below_read]
      * Kontakte
        * Adressverwaltung: [:group_and_below_full]
        * Kontakt: []
      * Ehrenmitglieder
        * Adressverwaltung: [:group_and_below_full]
        * Ehrenmitglied: []
      * Veteranen
        * Eidgenössischer Veteran: []
        * Eidgenössicher Ehrenveteran: []
        * CISM Veteran: []
    * Mitgliederverband
      * Mitgliederverband
        * Administrator: [:layer_and_below_full, :uv_lohnsumme]
        * Verantwortlicher SUISA: [:group_read, :song_census]
      * Geschäftsstelle
        * Geschäftsführung: [:layer_and_below_full, :finance]
        * Mitarbeiter: [:layer_and_below_full, :approve_applications, :finance]
        * Hilfe: [:layer_and_below_read]
      * Vorstand
        * Präsident: [:layer_full, :layer_and_below_read]
        * Vizepräsident: [:layer_and_below_read]
        * Kassier: [:layer_and_below_read, :finance]
        * Veteranenchef: [:layer_and_below_read]
        * Mitglied: [:layer_and_below_read]
      * Musikkommission
        * Präsident: [:layer_read, :group_and_below_full]
        * Mitglied: [:layer_read]
      * Arbeitsgruppe
        * Leitung: [:layer_read]
        * Mitglied: [:group_and_below_read]
      * Kontakte
        * Adressverwaltung: [:group_and_below_full]
        * Kontakt: []
      * Veteranen
        * Kantonaler Veteran: []
        * Kantonaler Ehrenveteran: []
    * Regionalverband
      * Regionalverband
        * Administrator: [:layer_and_below_full]
        * Verantwortlicher SUISA: [:group_read, :song_census]
      * Geschäftsstelle
        * Geschäftsführung: [:layer_and_below_full, :finance]
        * Mitarbeiter: [:layer_and_below_full, :approve_applications, :finance]
        * Hilfe: [:layer_and_below_read]
      * Vorstand
        * Präsident: [:layer_full, :layer_and_below_read]
        * Vizepräsident: [:layer_and_below_read]
        * Kassier: [:layer_and_below_read, :finance]
        * Veteranenchef: [:layer_and_below_read]
        * Mitglied: [:layer_and_below_read]
      * Musikkommission
        * Präsident: [:layer_read, :group_and_below_full]
        * Mitglied: [:layer_read]
      * Arbeitsgruppe
        * Leitung: [:layer_read]
        * Mitglied: [:group_and_below_read]
    * Kreis
      * Kreis
        * Administrator: [:layer_and_below_full]
        * Verantwortlicher SUISA: [:group_read, :song_census]
      * Geschäftsstelle
        * Geschäftsführung: [:layer_and_below_full, :finance]
        * Mitarbeiter: [:layer_and_below_full, :approve_applications, :finance]
        * Hilfe: [:layer_and_below_read]
      * Vorstand
        * Präsident: [:layer_full, :layer_and_below_read]
        * Vizepräsident: [:layer_and_below_read]
        * Kassier: [:layer_and_below_read, :finance]
        * Veteranenchef: [:layer_and_below_read]
        * Mitglied: [:layer_and_below_read]
      * Musikkommission
        * Präsident: [:layer_read, :group_and_below_full]
        * Mitglied: [:layer_read]
      * Kontakte
        * Adressverwaltung: [:group_and_below_full]
        * Kontakt: []
    * Verein
      * Verein
        * Administrator: [:layer_and_below_full, :festival_participation, :uv_lohnsumme]
        * DirigentIn: []
        * Verantwortlicher SUISA: [:group_read, :song_census]
        * Jugendverantwortlicher: [:group_and_below_full]
      * Vorstand
        * Präsident: [:layer_full, :layer_and_below_read]
        * Vizepräsident: [:layer_and_below_read]
        * Kassier: [:layer_and_below_read, :finance]
        * Veteranenchef: [:layer_and_below_read]
        * Materialverwaltung: [:layer_and_below_read]
        * Mitglied: [:layer_and_below_read]
      * Musikkommission
        * Präsident: [:layer_read, :group_and_below_full]
        * Mitglied: [:layer_read]
      * Mitglieder
        * Adressverwaltung: [:group_and_below_full]
        * Mitglied: [:layer_read]
        * Passivmitglied: []
        * Ehrenmitglied: []
      * Arbeitsgruppe
        * Leitung: [:layer_read]
        * Mitglied: [:group_and_below_read]
      * Kontakte
        * Adressverwaltung: [:group_and_below_full]
        * Kontakt: []
    * Global
      * Kontakte
        * Adressverwaltung: [:group_and_below_full]
        * Kontakt: []

(Output of rake app:hitobito:roles)
<!-- roles:end -->

## Glossar

| interner Name             | Domänenbegriff   |
| --------------            | --------------   |
| Concert                   | Aufführung       |
| Song                      | Werk             |
| SongCensus                | Meldeliste       |
| SongCount                 | Werkmeldung      |
| Event::GroupParticipation | Gruppenanmeldung |
| Event::Festival           | Musikfest        |

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

