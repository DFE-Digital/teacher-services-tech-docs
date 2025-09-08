# Schools Digital tech docs

This is the repo for the [Schools Digital tech docs](https://tech-docs.teacherservices.cloud).

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
