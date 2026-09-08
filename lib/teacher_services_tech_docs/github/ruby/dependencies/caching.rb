module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class Caching < DependencyDetectorBase
          def value
            caches = []

            caches << solid_cache_label if solid_cache_present? || solid_cache_store_configured?
            caches << "Redis" if redis_cache_present?
            caches << "Memory" if memory_cache_store_configured?
            caches << "Memcache" if mem_cache_store_configured?
            caches << "None (null store)" if null_store_configured?

            return caches.uniq.join(", ") if caches.any?

            "Unknown"
          end

        private

          def solid_cache_label
            version = get_dependency_version("solid_cache")
            return "SolidCache" unless version.present?

            "SolidCache #{version}"
          end

          def solid_cache_present?
            get_dependency_version("solid_cache").present? || gem_declared?("solid_cache")
          end

          def redis_cache_present?
            redis_cache_store_configured? || dependency_present?("redis")
          end

          def redis_cache_store_configured?
            production_environment_file_content&.include?(":redis_cache_store")
          end

          def solid_cache_store_configured?
            production_environment_file_content&.include?(":solid_cache_store")
          end

          def memory_cache_store_configured?
            production_environment_file_content&.include?(":memory_store")
          end

          def mem_cache_store_configured?
            production_environment_file_content&.include?(":mem_cache_store")
          end

          def null_store_configured?
            production_environment_file_content&.include?(":null_store")
          end
        end
      end
    end
  end
end
