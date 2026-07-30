serve:
    bundle exec middleman server

rubocop:
    bundle exec rubocop .

lint-yaml:
	uv tool run yamllint config

lint: rubocop lint-yaml