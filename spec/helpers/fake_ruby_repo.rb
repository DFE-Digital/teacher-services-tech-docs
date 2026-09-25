FakeRubyRepo = Struct.new(
  :service_name,
  :lockfile,
  :tool_versions_file,
  :ruby_version_file,
  :node_version_file,
  :nvmrc_file,
  :yarnrc_file,
  :package_json_file,
  :yarn_lock_file,
  :production_environment_file,
  :dfe_analytics_initializer_file,
  :terraform_files,
  :dockerfile,
  keyword_init: true,
) do
  def terraform_files
    self[:terraform_files] || {}
  end
end
