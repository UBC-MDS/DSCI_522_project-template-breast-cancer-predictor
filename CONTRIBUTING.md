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

We edit and run the code inside the container, by connecting Positron to it over ssh.
Your project folder is shared with the container at `/workspace`,
so a file you change there changes on your computer too.

<details>
<summary><strong>Once, before your first connection</strong></summary>

1. Install [Positron](https://positron.posit.co/download.html) on your computer.
   Its **Remote SSH** feature, which connects to the container, comes built in,
   so you don't need to install an extension.
2. Make sure you followed the [Usage section of the README](README.md#usage):
   you have an ssh key at `~/.ssh/id_ed25519.pub` and you ran `docker compose pull`.
3. Check that Git knows who you are on your computer:

   ``` bash
   git config --global user.email
   ```

   It should print the email of your GitHub account.
   If it prints nothing, set your name and email:

   ``` bash
   git config --global user.name "Your Name"
   git config --global user.email "you@example.com"
   ```

   `docker-compose.yml` shares your `~/.gitconfig` with the container,
   so the commits you make there count as yours.

</details>

<details>
<summary><strong>Each time you work on the project</strong></summary>

1. In a terminal, in the root of this repository, start the container in the background:

   ``` bash
   docker compose up -d
   ```

   `docker compose ps` should list `analysis-env` as running.
2. In Positron, open the Command Palette
   (`Cmd+Shift+P` on Mac, `Ctrl+Shift+P` on Windows).
3. Type and run **Remote SSH: Show Remote Menu**, then pick **Connect to Host**.
4. Type `root@localhost:2222` and press Enter. A new Positron window opens.
   * If it asks for the platform of the remote host, pick **Linux**.
   * If it asks whether you trust the host (a "fingerprint"), click **Continue**.
   * The first time, Positron installs its server inside the container. This takes a minute.
5. **Open the project folder.**
   The bottom left corner now shows `SSH: localhost:2222`,
   but the Explorer says **No folder opened** and the terminal starts in `/root`,
   which has no project files. That is normal.
   * Click **Open Folder** in the Explorer.
   * Delete what is in the path box at the top of the window, type `/workspace`, and press Enter.
   * The window reloads, and the Explorer shows **WORKSPACE [SSH: LOCALHOST:2222]** with the project files.
6. **Pick the Python interpreter** (check this every time).
   * Click the interpreter button at the top right of the window.
     The **Running Interpreter Sessions** menu only lists sessions that are already running
     (such as `/usr/bin/python3`, the container's system Python: not this one).
   * Click **New Console Session...** and pick
     **Python 3.x (uv: dsci-522-project-template-breast-cancer-predictor)**,
     with the path `/opt/venv/bin/python`. This is the environment built from `uv.lock`.
   * If it isn't in the list, run **Python: Select Interpreter** from the Command Palette,
     choose **Enter interpreter path...** and type `/opt/venv/bin/python`.
   * Don't pick `/workspace/.venv`: that is an environment from your own computer,
     and it doesn't run in the container.
   * To check, run `import sys; print(sys.executable)` in the Console.
     It should print `/opt/venv/bin/python`.
7. Work as usual. The Terminal, the Console and the **Render** button all run inside the container.
8. When you are done, close the Positron window,
   then stop and remove the container in a terminal on your computer:

   ``` bash
   docker compose down
   ```

</details>

<details>
<summary><strong>If it doesn't connect</strong></summary>

* **`~/.ssh/id_ed25519.pub` is a folder:** Docker made it because the key didn't exist yet.
  Run `docker compose down`, delete that folder, make the key
  (see the [README](README.md#usage)), and start again.
* **`~/.gitconfig` is a folder, or Git in the container doesn't know your name:**
  the same thing happened with your Git settings.
  Run `docker compose down`, delete that folder, set your name and email (see above), and start again.
* **It asks for a password:** the container can't see your key.
  Check that your key is named `id_ed25519.pub`, or change the key path in `docker-compose.yml`.
* **"Remote host identification has changed":** you are using a new image.
  Run `ssh-keygen -R "[localhost]:2222"`, then connect again.
* **GitHub asks you to sign in when you push from the container:**
  sign in once in the browser window Positron opens. Positron remembers it.
* **Linux laptops:** ssh refuses the key because the file belongs to you, not `root`.
  Remove the `#` from the `StrictModes no` line in the `Dockerfile` and push,
  so the workflow publishes a fixed image.
* **Port 2222 is already in use:** change the first `2222` in `docker-compose.yml`
  to another number (e.g. `2223`), and connect to that port instead.

More detail: [Working in a container over ssh with Positron](https://ubc-dsci.github.io/reproducible-and-trustworthy-workflows-for-data-science/lectures/containers-ssh-positron.html).

</details>

To re-run the analysis and render the report without opening the container:

``` bash
docker compose run --rm analysis-env uv run quarto render
```

### Adding or updating a package

On a new branch, add the package with `uv add <package>==<version>`
(this pins the version in `pyproject.toml` and updates `uv.lock`),
then commit the changed `pyproject.toml` and `uv.lock` together and push them.
GitHub Actions then builds and publishes a new image on Docker Hub,
and commits the new `sha-` tag to the `image:` line of `docker-compose.yml`
on your branch.
When the workflow finishes,
get that commit and download the new image:

``` bash
git pull
docker compose pull
```

Then merge the branch into `main` in a pull request.

### Publishing the report

The report on GitHub Pages is a copy of the rendered report in `docs/index.html`.
Each time you re-render the report, copy it there again, commit and push:

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
