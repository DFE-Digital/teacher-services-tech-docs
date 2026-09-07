module SchoolsDigitalTechDocs
  module GitHub
    module Ruby
      module Dependencies
        class JobQueues < CompilationBase
          def value
            queues = []

            queues << format_queue("Sidekiq", "sidekiq") if dependency_present?("sidekiq")
            queues << format_queue("SolidQueue", "solid_queue") if dependency_present?("solid_queue")
            queues << format_queue("GoodJob", "good_job") if dependency_present?("good_job")

            return queues.uniq.join(", ") if queues.any?

            "None"
          end

        private

          def format_queue(name, gem_name)
            version = get_dependency_version(gem_name)
            return name unless version.present?

            "#{name} #{version}"
          end

          def dependency_present?(gem_name)
            get_dependency_version(gem_name).present? || gem_declared?(gem_name)
          end
        end
      end
    end
  end
end
