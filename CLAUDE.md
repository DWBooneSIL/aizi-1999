# CLAUDE.md

Project context for the aizi-1999 dataset pipeline. **Draft** - drawn from the
documents in `background/`; open questions are listed at the end and should be
resolved by the researcher before the pipeline steps that depend on them.

## What this dataset is

A sociolinguistic survey of the Aizi (Aïzi) language communities on the Ebrié
Lagoon, Côte d'Ivoire, carried out by SIL Côte d'Ivoire from **21-30 June
1999** in seven villages of the Sous-Préfecture de Jacqueville: Tiagba,
Nigui-Saff, Attoutou-A, Abraco, Abraniamiambo, Taboth, Attoutou-B.

Primary goal: decide whether French is adequate for the needs of the Aizi
community (especially churches), or whether Adioukrou or one or more of the
three Aizi languages need development. Research questions: level, stability
and homogeneity of French proficiency; church use of French and French
materials; attitudes toward French.

Published result: Boone, Silué & Augustin (2002), *L'utilisation du français
et de l'adioukrou par les Aizi*, SIL Electronic Survey Report 2002-047
(reprinted from *Journal of West African Linguistics*) -
`background/Boone_et_al.-Aizi__SILESR2002_047.pdf`.

## How it was collected

The raw data is **four data sheets** in one Google Sheet:
https://docs.google.com/spreadsheets/d/1bWNKE4LJM3KHVYtBDOJso3VpNtp0IIwlC5Zq7fuOE88/
(readable by link; see the fetching caveat below).
The four sheets do **not** map one-to-one onto the report's four instruments:

| Instrument | Unit | Reported size | In the data? |
|---|---|---|---|
| Group interview with chief and notables | village | one per village (7) | **No** - results not presented; only the report narrative survives |
| Individual interview, standard form (report appendix): language use, self-rated proficiency in Adioukrou/French, language attitudes | person | 193 (233 total minus Attoutou-B's 40); ~40 per village, 24 each at Abraco and Abraniamiambo, 32 at Nigui-Saff | Yes |
| Individual interview, Attoutou-B form (`Légendes_aizi.pdf`): first language of self/parents/spouse/children, Adioukrou and Alladian comprehension, "the other" Aizi variety, French | person | 40 | Yes |
| Religious-leader interview (language by part of service, Bible versions, congregation size) | congregation/leader | 25 | Yes |
| French sentence-repetition test (TCF): 3 practice + 15 scored items, 0-3 points each, total 0-45, mapped to ETS levels 0+ to 3 | person | 221 reported (122 with 1-6 yrs school, 99 with 7+); many unschooled refused | Yes |

Attoutou-B (two quarters: lélémrin and apro) used a different individual
interview form from the other six villages. The two forms share the same
response codes, but their questions barely overlap.
`background/Légendes_aizi.pdf` is the coding key for the Attoutou-B form and
for the church interview.

**Design decision (researcher):** the four sheets are **four complementary
datasets from the same survey**. Each serves different research questions.
They are kept as separate tables. The two individual-interview forms are
**not** forced into one harmonized table. They share only the demographic
columns and the response-code lookups.

Scoring rules for the TCF are in `background/TCF-NOTE.DOC` (RTF despite the
extension; so are `proposal.doc` and `Prop_fr.rtf`).

### The four sheets (profiled 2026-10-08)

The sheet is now readable by link. **Fetching caveat:** the plain
`/export?format=csv|xlsx` URLs still return 401. The `gviz/tq?tqx=out:csv`
endpoint works but **silently blanks 86 cells**: header names (`AGE`, `ECOLE`,
`AILLE`, `7a`, `7b`), `?` answers, and free-text counts like "50 ou 60".
gviz keeps only each column's majority type. The `htmlview/sheet?gid=` rendering
matched cell-for-cell where gviz didn't, and it lost nothing. Step 3 must
fetch either from htmlview or through the authenticated Sheets API
(`googlesheets4`), never via gviz.

| Sheet (gid) | Rows | ID | Content |
|---|---|---|---|
| `TCF` (1651465916) | 292 | T001-T292 | REPEATER, VILLAGE (full name, e.g. TIAGBA), SEXE, AGE, ECOLE (years of school), EGLISE, NOTE (total raw score 0-45). By design the test keeps **only the total**; the ETS level is derived from it, and item scores were never retained. 35 scores of 0. The 221 in the report is a subset. |
| `Intvw_indiv_1` (1663731106) | 193 | I001-I193 | Standard form, 6 villages (village *codes*). RESPONDENT, VILLAGE, SEXE, AGE, ECOLE, NE(E) birthplace, AILLE[URS] years elsewhere, Q1a-12c per the report appendix, NOTE TCF |
| `Intvw_indiv_2` (761383886) | 40 | I194-I233 | Attoutou-B form. Same demographics plus **QUARTIER** (`anc`/`nou`/`nou?`), Q1a-7b per the legend, NOTE TCF |
| `Intvw_égl` (1444925289) | 25 | E01-E25 | Church: Village, Église, 1a-9b per the report appendix, commentaires (free text, French) |

Interview IDs run continuously across the two forms (I001-I233), which
matches the report's 233. **No interviewer or date columns, and no names.**

**Interview to TCF relationship:** there is no join key, and **no linkage
will be attempted**. When an interviewee was also a test-taker ("repeater"),
their score is copied into the interview sheet's `NOTE TCF` column. That
column is an attribute of the interview record, not a foreign key. `Q`
appears in 18 rows. **Decided:** treat `Q` as missing (NA). Religion (`EGLISE`) was recorded only
for repeaters, in the TCF sheet, never for interviewees.

**Derived field:** the ETS proficiency level is computed from the TCF raw
score using the report's bands: 0-12 → 0+, 13-15 → 1, 16-18 → 1+, 19-22 → 2,
23-25 → 2+, 26-45 → 3+. It applies to `NOTE` in the TCF sheet and to
`NOTE TCF` in the interview sheets.

**Data-quality issues for the crosswalks:**
- **Language codes in the data:** `AHM` is already used for Mobumrin (not in
  the legend). Variants include `FR`, `FRFA`, `DIO`, `AIZ`, `ARABE` and
  `BETE`. Numeric codes `3`/`4` appear in language fields (see "Incomplete
  language lists" below).
  List separators are inconsistent (`,` `, ` `.`).
  - **Decided:** `FRFA` is an error for `FRA`, so it becomes `fra`.
  - **Decided:** `AIZ` means "an Aizi variety" as opposed to French,
    Adioukrou or Alladian. Resolve it to `ahi`/`ahp`/`ahm` from context
    where possible (village, quarter, respondent's own first language).
    Otherwise keep it as an unresolved Aizi value with a flag. Do not
    invent a code.
- **Church language strings** are letter clusters, not lists. For example,
  `ADF&` = A+D+F+?. Lowercase marks translation (`Fa` = French translated
  into Aizi). **Decided:** `(F)A` = F + A, with the parentheses dropped. `&`
  (undefined in the legend) means "along with others"; see "Incomplete
  language lists" below.
  Values like `oui`, `non`, `qqfois` and `peu` are mixed in.
- **Uncertainty markers** need to be kept as flags: `?`, `1?`, `B?`, `M?`,
  `nou?`, `2?` and `100?`. Typos like `f` for `F`, `m` for `M`, and stray
  `2`/`5` in yes/no fields also need fixing.
- **SEXE has `N`** in 3 TCF rows. **Decided:** `N` = not recorded, so it
  becomes missing (NA), not a third category. EGLISE has `,M` in 1 row.
- **TCF EGLISE `N` = 89 of 292.** That is implausibly many for Papa Nouveau
  (3 of 25 congregations). **Decided:** in the TCF sheet `N` = *néant* (no
  religion). In the church sheet `N` stays Papa Nouveau, so the same letter
  needs a per-sheet crosswalk.
- **Birthplace** is free text with variants (`NIGUI.SAFF`, `ABRANIA`,
  `TOUPA`/`TOUPAH`, `Attoutou B`) that need a place crosswalk.

### Incomplete language lists (decided in principle; format to confirm)

Some answers don't give a strict list of languages:
- **`3` / `4` in an individual-interview language field** = the expected
  languages plus others, totalling 3 or 4, with the languages themselves
  not listed.
- **`&` in a church language string** (e.g. `ADF&`) = the listed languages
  plus others.

Using many languages is treated as a relevant fact in its own right, not
as missing data. Proposed format: the long `* x language` tables hold one row
per *named* language. The parent row (respondent x domain, or congregation x
service function) carries:

- `language_list_status`:
  - `complete` - every language used is listed
  - `listed_plus_others` - church `&`
  - `count_only` - `3`/`4` with no languages named; zero language rows
- `n_languages_reported`: the stated count (3 or 4) for `count_only`;
  otherwise the number of languages listed.

Analysis rule: when probing preferential use of one or two languages, **set
aside** answers with `count_only`. Whether to also set aside
`listed_plus_others` is **deferred until data exploration** (researcher). Keep
both statuses distinct so either choice remains a simple filter.

### Coding scheme (from the legend)

- Villages: TI, NS, AA, AC, AN, TA, AB.
- Responses (shared by both individual-interview forms): 0 no, 1 yes, B bien,
  M moyennement, P un peu, `*` yes if visitors, `(-)` no answer.
- Languages: the 1999 data uses upper-case codes from that era (Ethnologue
  13th ed. and ad hoc). **Decision: normalize every language to its current
  ISO 639-3 code, three lower-case letters.** Crosswalk (`crosswalks/`):

  | 1999 code(s) | Language | Current code |
  |---|---|---|
  | AHI, LEL, CHI; church `A` where lect is lélémrin | Tiagbamrin Aizi (lélémrin / chicalé) | `ahi` |
  | AHP, TCH, APR; church `A` where lect is apro | Aproumu Aizi (apro / tchavamrin) | `ahp` |
  | church `A` at Abraco / Abraniamiambo | Mobumrin Aizi | `ahm` |
  | ADI, ADJ; church `D` | Adioukrou | `adj` |
  | FRA; church `F` | French | `fra` |
  | ALL; church `L` | Alladian | `ald` |
  | AVI; church `K` | Avikam | `avi` |
  | ABI | Abidji | `abi` |
  | BCI; church `B` | Baoulé | `bci` |
  | WOB | Wè Northern (Wobé) | `wob` |
  | church `E` | Ebrié | `ebr` |
  | DIO | Dioula (Jula), trade language - researcher's best guess | `dyu` |
  | FRFA | error for FRA (researcher) | `fra` |
  | BETE | Bété - no single ISO code for the cluster (e.g. `bev` Daloa, `btg` Gagnoa) | unresolved; keep as a flagged value |

  Church interviews use one-letter codes, with `A` meaning "the local Aizi
  language". `A` must be resolved to `ahi` / `ahp` / `ahm` from the village
  (and, at Attoutou-B, the quarter if recorded). Compound codes (`Af` = Aizi
  translated into French; `A; F` = Aizi, plus French when visitors attend)
  become multiple rows with a qualifier, not new language codes.
- Denominations: M Methodist, C Catholic, N Papa Nouveau, Q Messianic, H
  Harrist, J Jehovah's Witness, A other.
- Bible versions: LS Louis Segond, FC français courant, TMN New World
  Translation, TOB Traduction Œcuménique.

## Respondents, PII and disclosure risk

Respondents are adult residents of small lagoon villages (the proposal gives
~8000 speakers for the two Kru languages and ~4000 for the Kwa one), plus
village chiefs/notables and church leaders.

**Direct identifiers:** the forms asked for names, but **respondent names
were not retained** in the data, and there are no interviewer or date
columns. Rare free-text values are quasi-identifiers too: a birthplace
outside the area (e.g. a single `ALEPE` or `BOUAKE`) and a prayer language
like `ARABE`, which also implies religion.

**Quasi-identifiers:** village, age, sex, schooling level, birthplace, years
lived elsewhere, religion, first language of self/parents/spouse/children.

**Special-category data:** religion (TCF form) and religious practice
(praying or "worshipping a fetish" in a given language).

**Elevated risks:**
- **Language + location identifies the group:** mobumrin is spoken only at
  Abraco and Abraniamiambo, and Attoutou-B's two quarters each map to one
  language. Any record with a mother-tongue field effectively names a village
  pair or a single quarter, even without a village field.
- **Religious leaders are effectively identified:** village + denomination
  usually points to a single named pastor or priest.
- **Small religious groups:** Papa Nouveau, Messianic and Jehovah's Witness
  members in a village of a few hundred adults may be unique on religion +
  sex + age band.
- **Small cells:** age x sex x schooling x village cells are small (24-40
  people per village).
- **Chiefs/notables:** these are public roles, so village-level group
  interview data is identifying by design.
- **Time elapsed:** the data is now 27 years old, so many older respondents
  may be deceased. That lowers the risk of harm, but it does not remove
  identifiability for their families.

## Candidate entities (tables)

- `village` - code, name, local names, sous-préfecture, population estimate,
  facilities (school, market, health centre, maternity), literacy classes.
- `lect` / `language` - Aizi varieties and neighbouring languages, with
  glossonyms/ethnonyms per village (report §2.3 table) and code crosswalk.
- `village_lect` - which lect(s) each village / quarter speaks (Attoutou-B
  has two).
The tables are organized around the **four complementary datasets**. No
cross-dataset person linkage is attempted.

- `respondent` - individual interviewee (I001-I233, both forms): form
  (standard / Attoutou-B), village, quarter (Attoutou-B only), sex, age,
  schooling, birthplace, years elsewhere, TCF score if a repeater, plus the
  derived ETS level. No religion.
- Standard form (I001-I193), from the report-appendix questions:
  - `language_use` - respondent x domain (local celebrations, spouse,
    children, friends, prayer) x language.
  - `proficiency_self_report` - Adioukrou and French understanding,
    speaking and functional ability.
  - `language_attitude` - pairwise "which is more important" answers.
- Attoutou-B form (I194-I233), from the legend questions:
  - `family_language` - first language of self, father, mother, spouse and
    children.
  - Its own language-use and comprehension answers (Adioukrou, Alladian,
    the other Aizi variety, French).
  - These share lookups with the standard form, but not columns.
- `tcf_test` - one row per test-taker (T001-T292): village, sex, age,
  schooling, religion (`néant` allowed), total raw score, and the derived
  ETS level. Item scores were never retained.
- `tcf_item` - sentence text and scoring notes (from TCF-NOTE), as
  documentation only.
- `congregation` - village x denomination, membership, typical attendance.
- `congregation_language_use` - congregation x service function x language.
- `congregation_bible_version` - congregation x version.
- Lookups: `denomination`, `bible_version`, `response_level`, `researcher`.

## Survey language and translation (Step 6)

All instruments, legends, codes and the report are in **French**. Only the
report abstract exists in English. The wide-audience target is English, so
**Step 6 applies**: `data-clean/` should split into `data-clean-fra/` and
`data-clean-eng/`.

Things to translate: value labels, response categories, and any free-text
comments. Things to keep untranslated: village names, glossonyms and
language names.

## Collaborators and infrastructure

- **Survey team (five people):** Douglas Boone (team lead), Anguié Marie
  Florence, MaryAnne Augustin, Séri Kpapo Guy Roland (one person), Silué
  Lamine.
- **Report authors:** Boone, Silué Lamine, Augustin.
- **Institutions:** SIL Côte d'Ivoire (Société Internationale de
  Linguistique). The Adioukrou translation project and the Methodist church
  are mentioned as stakeholders.
- **Repository:** github.com/DWBooneSIL/aizi-1999.
- **Raw data:** Google Sheet (four data sheets), linked above.
- **Ethics:** SIL Global has no IRB. The **SIL Strategic Research Office**
  signs off on ethical decisions about data publication, including the
  disclosure-control choices for `data-public/` (Step 12).

## Open questions

1. **Codes:** all settled. `(F)A` (one cell, E02 Q1e) counts as both F and
   A; the parentheses' possible hesitation on F is not retained. Still
   pending: whether to exclude `listed_plus_others` from one-or-two-language
   preference analyses, which awaits data exploration.
2. **Canonical fetch method:** htmlview scraping works anonymously but is
   brittle. `googlesheets4` is robust but needs each collaborator's Google
   login. Should the canonical copy stay this Google Sheet?
3. **Collaborator access:** who needs read/write access, and whether any
   unattended or CI runs need credentials.
4. **Consent:** what consent was obtained in 1999? This is input for the
   Strategic Research Office's sign-off.
5. **Interview language:** were interviews with non-French speakers conducted
   through an interpreter in Aizi?
6. **Report inconsistencies to reconcile against the data:**
   - 12 villages (proposal) vs. 13 (report).
   - Nigui-Saff's 32 interviews vs. "at least 40" per village.
7. **Bété:** which variety (if any) the 1999 `BETE` responses refer to.
