# aizi-1999
Research into language use and language proficiency among the Aizi of Ebrie Lagoon, Ivory Coast

## Repository Structure

- `background/` - Existing project documents (proposal, prior reports, ethics protocol, survey instrument).
- `crosswalks/` - Hand-reviewed variant-to-canonical value mappings.
- `translations/` - Hand-reviewed original-language-to-English mappings, if the survey wasn't conducted in English.
- `data-raw/` - Stage 1: the fetched raw file(s); only the manifest is tracked, the payload is git-ignored.
- `data-clean/` - Stage 2: raw data with crosswalks applied, fully documented (may split into `data-clean-[code]/` and `data-clean-eng/` if this project translates).
- `data-full/` - Stage 3: the full tidy relational dataset, for project insiders only.
- `data-public/` - Stage 4: the desensitized, publication-ready dataset.
- `R/` - Pipeline functions called in sequence by `build.R`, plus the hand-run `check_dependencies.R`.
- `sdc/` - Disclosure-control configuration, if this project needs it.
- `output/` - Generated Zenodo deposit bundle (`datapackage.json`, CSV/Parquet, docs) built from `data-public/`.
- `docs/` - Diagnostic report, domain model proposal, ER diagram, and codebook.
- `paper/` - Companion data paper, if one is planned.
- `.gitignore` - Excludes data payloads, credentials, and per-person machine/R session files.
- `README.md` - This file.
- `CLAUDE.md` - Project context for Claude Code.
- `aizi-1999.Rproj` - RStudio Project file that sets the repository root as R's working directory.

## For Collaborators Running This Pipeline

If you work in RStudio directly rather than through Claude Code:

1. **Refresh your local clone before starting work** - someone else may have
   pushed changes since you last opened the project. In GitHub Desktop:
   *Fetch origin*, then *Pull*. From a terminal: `git pull`.
2. **Open `aizi-1999.Rproj`** to launch RStudio with the working directory
   already set to the repository root.
3. **Install this pipeline's R package dependencies and run it:**

   ```r
   source("R/check_dependencies.R")
   source("build.R")
   ```
