# Contributing to the Breast Cancer Predictor project

This outlines how to propose a change to the Breast Cancer Predictor project.

### Fixing typos

Small typos or grammatical errors in documentation may be edited directly using
the GitHub web interface, so long as the changes are made in the _source_ file.

*  YES: you edit the Quarto source file `reports/breast_cancer_predictor_report.qmd`.
*  NO: you edit the rendered `reports/breast_cancer_predictor_report.html` or `.pdf`.

### Prerequisites

Before you make a substantial pull request, you should always file an issue and
make sure someone from the team agrees that it's a problem. If you've found a
bug, create an associated issue and illustrate the bug with a minimal
[reprex](https://www.tidyverse.org/help/#reprex).

### Setting up the project

We develop in the same Docker container that users run the analysis in,
so everyone uses the same software and package versions.
First follow the [Usage section of the README](README.md#usage)
(install Docker, clone the repository, make an ssh key, and download the image).
Run all the commands below from the root of this repository.

### Working in the container

Start the container with:

``` bash
docker compose up -d
```

Then connect to it with Positron over ssh
(see [Working in a container over ssh with Positron](https://ubc-dsci.github.io/reproducible-and-trustworthy-workflows-for-data-science/lectures/containers-ssh-positron.html)).
When you are done, stop the container with:

``` bash
docker compose down
```

To re-run the analysis and render the report without opening the container:

``` bash
docker compose run --rm analysis-env uv run quarto render
```

### Adding or updating a package

Add the package with `uv add <package>==<version>`
(this pins the version in `pyproject.toml` and updates `uv.lock`),
then commit the changed `pyproject.toml` and `uv.lock` together and push them.
GitHub Actions then builds and publishes a new image on Docker Hub.
When the workflow finishes,
change the `sha-` tag on the `image:` line of `docker-compose.yml`
to the new tag (in a pull request),
and download the new image with:

``` bash
docker compose pull
```

### Publishing the report

The report on GitHub Pages is a copy of the rendered report in `docs/index.html`.
Each time you re-render the report, copy it there again and push:

``` bash
cp reports/breast_cancer_predictor_report.html docs/index.html
```

### Pull request process

*  Create a new Git branch for each pull request (PR), starting from an
   up-to-date `main`. Do not commit directly to `main`.
*  Give the branch a short name that describes the work,
   for example `fix-readme-typo` or `add-eda-figure`.
*  Keep each branch small: one independent piece of work per branch.
*  Before opening the PR, render the report in the container
   (`docker compose run --rm analysis-env uv run quarto render`)
   to check that the analysis still runs from start to finish.
*  Open a PR into `main` and describe what changed and why.
   Link the related issue (e.g., "Closes #12").
*  At least one other team member must review and approve the PR before it is merged.
   The reviewer, not the author, merges it.
*  New code should follow the PEP8 [style guide](https://peps.python.org/pep-0008/).

### Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to
abide by its terms.

### Attribution

These contributing guidelines were adapted from the [dplyr contributing guidelines](https://github.com/tidyverse/dplyr/blob/master/.github/CONTRIBUTING.md).
