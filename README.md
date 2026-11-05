# Schools Digital tech docs

This is the repo for the [Schools Digital tech docs](https://tech-docs.teacherservices.cloud).

### Install build dependencies with ASDF

The required versions of build tools are defined in [.tool-versions](.tool-versions). These can be automatically installed with [asdf-vm](https://asdf-vm.com/), see their [installation instructions](https://asdf-vm.com/#/core-manage-asdf).

Install the plugins specified in `.tool-versions`

```bash
asdf plugin add ruby
asdf plugin add nodejs
asdf install
bundle install
```

(We don't mandate asdf, you can use other tools if you prefer.)

Ruby and Node.js are both required: the Tech Docs template uses Node.js to render
GOV.UK components and build frontend assets. Ruby's version is also recorded in
`.ruby-version` for CI; keep it in sync with `.tool-versions`.

## Developing on this project

Copy `.env.example` to `.env` and populate a GitHub token with read access to repos.

To preview your new website locally, navigate to your project folder and run:

```sh
bundle exec middleman server
```

👉 See the generated website on `http://localhost:4567` in your browser. Any content changes you make to your website will be updated in real time.

To shut down the Middleman instance running on your machine, use `ctrl+C`.

If you make changes to the `config/tech-docs.yml` configuration file, you need to restart Middleman to see the changes.

## Tests

Run the RSpec suite with:

```sh
bundle exec rake
```

The suite includes a GOV.UK service-navigation smoke test using the site's
configuration, the installed Tech Docs templates, and a real Node.js process.
It does not mock the renderer or make GitHub API requests. This catches Node.js
startup failures and missing Nunjucks or GOV.UK Frontend templates that unit
tests of the Ruby helpers alone cannot detect.

To run just that test:

```sh
bundle exec rspec spec/govuk_components_spec.rb
```

## Build

To build the HTML pages from content in your `source` folder, run:

```
bundle exec middleman build
```

Every time you run this command, the `build` folder gets generated from scratch. This means any changes to the `build` folder that are not part of the build command will get overwritten.

## Deployment

The site is deployed automatically to the AKS production cluster whenever `main` branch is updated.

## Troubleshooting

### GOV.UK components fail to load when using asdf

If `Could not load GOV.UK component govukServiceNavigation` is preceded by
`No version is set for command node`, asdf cannot select Node.js for the
component-rendering subprocess. Tech Docs starts this process from its installed
gem directory, outside the repository, so asdf cannot find this project's
`.tool-versions`. A successful `node --version` in the repository does not rule
this out.

From the repository root, export the project's Node.js version so subprocesses
inherit it, then restart Middleman:

```sh
export ASDF_NODEJS_VERSION="$(awk '$1 == "nodejs" { print $2 }' .tool-versions)"
bundle exec middleman server
```

Run `bundle exec rspec spec/govuk_components_spec.rb` in the same shell to check
component rendering. The override is local to that shell; it does not change
your global asdf defaults or the installed gem.

For other component-loading errors, inspect the underlying error printed before
the wrapper message rather than assuming it is the same Node.js version issue.

Run `bundle update` to make sure you're using the most recent Ruby gem versions.

Run `bundle exec middleman build --verbose` to get detailed error messages to help with finding the problem.

## Licence

Unless stated otherwise, the codebase is released under [the MIT License][mit]. The documentation is [© Crown copyright][copyright] and available under the terms of the [Open Government 3.0][ogl] licence.

[mit]: LICENCE
[copyright]: http://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/
