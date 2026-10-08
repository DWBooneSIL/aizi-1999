# R/

Pipeline functions: normalization, dm-building, labelling, and packaging.
They are called in sequence by `build.R` at the repository root (created in
Step 5), which takes the place of a `scripts/` folder.

Also holds `check_dependencies.R`, which a collaborator runs by hand to
install required packages. `build.R` never sources it.
