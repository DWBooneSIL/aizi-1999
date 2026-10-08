# data-clean/ (stage 2)

Raw data with crosswalks applied, fully documented (Step 5). Entirely
generated and git-ignored, except a hand-maintained `<table>_dictionary.csv`
(and, where needed, `<table>_value_labels.csv`) per file.

If this project translates (Step 6), this single folder becomes two,
explicitly named `data-clean-[code]/` (original language) and
`data-clean-eng/` (English) - both real, equally-documented deliverables,
not a placeholder plus a derived copy.

## The four data stages

The folders `data-raw/`, `data-clean/`, `data-full/`, and `data-public/` hold
the four successive stages the data passes through:

1. `data-raw/` - the fetched raw file(s)
2. `data-clean/` - raw data with crosswalks applied, fully documented
3. `data-full/` - the full tidy relational dataset, for project insiders only
4. `data-public/` - the desensitized, publication-ready version

Apart from each folder's README, everything in them is fetched or regenerated
by the pipeline rather than committed, with these named exceptions:

- `data-raw/`: the manifest describing the raw file(s).
- From `data-clean/` onward: a `<table>_dictionary.csv` for every table and,
  where a table has coded fields, a `<table>_value_labels.csv`. Claude drafts
  these once; the researcher maintains them by hand afterward.
