# Breast Cancer Predictor

**Authors:** Tiffany Timbers, Melissa Lee, Joel Ostblom, Daniel Chen & Kehan Sky Sheng

Demo of a data analysis project for DSCI 522 (Reproducible and Trustworthy Data Science Workflows); a
course in the Master of Data Science program at the University of
British Columbia.

## About

Here we attempt to build a classification model using the k-nearest
neighbours algorithm which can use breast cancer tumour image
measurements to predict whether a newly discovered breast cancer tumour
is benign (i.e., is not harmful and does not require treatment) or
malignant (i.e., is harmful and requires treatment intervention).
Our final classifier performed fairly well on an unseen test data set,
with an F2 score (beta = 2) of 0.96
and an overall accuracy of 0.98. Of the 171 test data cases,
it correctly predicted 168.
It incorrectly predicted 3 cases,
and all of these were false negatives: predicting that a tumour is benign
when in fact it is malignant.
This kind of incorrect prediction is the most harmful in this context,
because it could delay treatment for a patient who needs it,
and as such we recommend further research to improve the model
before it is ready to be put into production in the clinic.

The data set that was used in this project is of digitized breast cancer
image features created by Dr. William H. Wolberg, W. Nick Street, and
Olvi L. Mangasarian at the University of Wisconsin, Madison (Street,
Wolberg, and Mangasarian 1993). It was sourced from the UCI Machine
Learning Repository (Dua and Graff 2017) and can be found
[here](https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+\(Diagnostic\)).
Each row in the data set represents summary statistics from measurements
of an image of a tumour sample, including the diagnosis (benign or
malignant) and several other measurements (e.g., nucleus texture,
perimeter, area, etc.). Diagnosis for each image was conducted by
physicians.

## Report

The final report can be found
[here](https://ubc-mds.github.io/DSCI_522_project-template-breast-cancer-predictor/)
(HTML), or as a
[PDF](reports/breast_cancer_predictor_report.pdf).

## Usage

We run the analysis in a Docker container,
so everyone uses the same software and package versions.
The image is published on Docker Hub at
[skysheng7/breast-cancer-predictor-2026](https://hub.docker.com/r/skysheng7/breast-cancer-predictor-2026).

### Setup

First time running the project,
install and launch [Docker](https://www.docker.com/get-started/),
then clone this repository and move into it:

``` bash
git clone https://github.com/UBC-MDS/DSCI_522_project-template-breast-cancer-predictor.git
cd DSCI_522_project-template-breast-cancer-predictor
```

Run all the commands below from the root of this repository.

### 1. Make an ssh key

If you don't have an ssh key yet, make one
and press Enter at each question:

``` bash
ssh-keygen -t ed25519
```

The container lets you log in with this key.
If you skip this step, Docker makes a *folder* named `~/.ssh/id_ed25519.pub` instead,
and connecting to the container over ssh fails
until you delete that folder and make the key.

### 2. Download the image

``` bash
docker compose pull
```

### 3. Run the analysis and render the report

``` bash
docker compose run --rm analysis-env uv run quarto render
```

Rendering runs the whole analysis from scratch:
it downloads the data again from the UCI Machine Learning Repository
(so you need an internet connection),
and overwrites the files in `data/raw/` and `data/processed/`.
The rendered report is written to
`reports/breast_cancer_predictor_report.html` and
`reports/breast_cancer_predictor_report.pdf`,
replacing the versions in this repository.

## Contributing

Want to change the analysis, add a package, or update the published report?
See [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Dependencies

- [Docker](https://www.docker.com/)
- The image is built from the [`Dockerfile`](Dockerfile) in this repository.
  It installs Quarto, uv,
  and Python with the packages listed in [`pyproject.toml`](pyproject.toml)
  (exact versions are locked in [`uv.lock`](uv.lock)).

## AI use statement

We used Anthropic [Claude Code](https://claude.com/claude-code) Opus 5.5 to help adapt this
project from conda and Jupyter to uv and Quarto.
All AI-generated changes were reviewed, tested, and edited by the authors,
who take full responsibility for the content of this repository.

Our instructions for the AI assistant are in [`CLAUDE.md`](CLAUDE.md). Asking the assistant to act as a tutor rather than do the work:
to guide us step by step, explain why, and critique our work honestly.

## License

The Breast Cancer Predictor report contained herein is licensed under the
[Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0) License](https://creativecommons.org/licenses/by-nc-sa/4.0/).
See [the license file](LICENSE.md) for more information. If
re-using/re-mixing please provide attribution and link to this webpage.
The software code contained within this repository is licensed under the
MIT license. See [the license file](LICENSE.md) for more information.

## References

Dua, Dheeru, and Casey Graff. 2017. "UCI Machine Learning Repository."
University of California, Irvine, School of Information; Computer
Sciences. <http://archive.ics.uci.edu/ml>.

Street, W. Nick, W. H. Wolberg, and O. L. Mangasarian. 1993. "Nuclear
feature extraction for breast tumor diagnosis." In *Biomedical Image
Processing and Biomedical Visualization*, edited by Raj S. Acharya and
Dmitry B. Goldgof, 1905:861–70. International Society for Optics;
Photonics; SPIE. <https://doi.org/10.1117/12.148698>.
