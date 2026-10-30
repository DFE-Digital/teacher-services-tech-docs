# Schools Digital tech docs

This is the repo for the [Schools Digital tech docs](https://tech-docs.teacherservices.cloud).

## Developing in a dev container

The dev container provides Ruby, native build tools, Node.js for the JavaScript runtime used by Middleman, and YAML linting. You do not need Ruby installed on your computer.

1. Install a Docker-compatible container engine and the [VS Code Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers). Make sure the container engine is running.
2. Clone this repository, open it in VS Code, and run **Dev Containers: Reopen in Container**. The first setup downloads the image and installs the gems from `Gemfile.lock`.
3. In the container terminal, copy `.env.example` to `.env` if you do not already have one. Populate `GITHUB_TOKEN` with a token that has read access to the repositories listed in `config/services.yml`, including organisation authorization where required. Keep `.env` untracked.
4. Start the preview:

   ```sh
   bundle exec middleman server --bind-address 0.0.0.0
   ```

5. Open `http://localhost:4567`. If that local port is already in use, use the forwarded address shown in VS Code's **Ports** panel instead.

Local content changes use Middleman's live reload. Stop the server with `ctrl+C`; restart it after changing `config/tech-docs.yml`.

Run the checks inside the container:

```sh
bundle exec rake
bundle exec rubocop .
yamllint config
```

Tests use `.env.test` and do not need a real GitHub token. The preview and `bundle exec middleman build` fetch content from GitHub and require a working token and network access.

Run `bundle install` after dependency changes. After changing the container configuration, run **Dev Containers: Rebuild Container**. Gems are stored in the container, so rebuilding can require reinstalling them; your checkout and existing `.env` remain in the mounted workspace.

If gem installation fails, inspect the container setup log, fix the reported problem, and rerun `bundle install` in the container terminal. For GitHub access failures, check the token's expiry, repository access and organisation authorization, then restart Middleman.

When upgrading Ruby, update `.devcontainer/Dockerfile` alongside `.ruby-version` and `.tool-versions`. Keep its Bundler version aligned with `Gemfile.lock`.

## Developing without a container

### Install build dependencies with ASDF

The required versions of build tools are defined in [.tool-versions](.tool-versions). These can be automatically installed with [asdf-vm](https://asdf-vm.com/), see their [installation instructions](https://asdf-vm.com/#/core-manage-asdf).

Install the plugin specified in `.tool-versions`

```bash
asdf plugin add ruby
asdf install
```

(We don't mandate asdf, you can use other tools if you prefer.)

## Developing on this project

Copy `.env.example` to `.env` and populate a GitHub token with read access to repos.

To preview your new website locally, navigate to your project folder and run:

```sh
bundle exec middleman server
```

👉 See the generated website on `http://localhost:4567` in your browser. Any content changes you make to your website will be updated in real time.

To shut down the Middleman instance running on your machine, use `ctrl+C`.

If you make changes to the `config/tech-docs.yml` configuration file, you need to restart Middleman to see the changes.

## Build

To build the HTML pages from content in your `source` folder, run:

```
bundle exec middleman build
```

Every time you run this command, the `build` folder gets generated from scratch. This means any changes to the `build` folder that are not part of the build command will get overwritten.

## Deployment

The site is deployed automatically to the AKS production cluster whenever `main` branch is updated.

## Troubleshooting

Run `bundle update` to make sure you're using the most recent Ruby gem versions.

Run `bundle exec middleman build --verbose` to get detailed error messages to help with finding the problem.

## Licence

Unless stated otherwise, the codebase is released under [the MIT License][mit]. The documentation is [© Crown copyright][copyright] and available under the terms of the [Open Government 3.0][ogl] licence.

[mit]: LICENCE
[copyright]: http://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/
