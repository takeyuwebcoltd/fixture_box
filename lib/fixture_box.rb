# frozen_string_literal: true

require "fixture_box/version"

class FixtureBox

  def initialize(data, class_names={})
    data = data.stringify_keys
    class_names = class_names.stringify_keys

    Dir.mktmpdir do |tmp_fixtures_dir|
      decorated_fixture_set_names = []
      decorated_class_names = {}
      data.each do |fixture_set_name, fixture_data|
        fixture_class = class_names[fixture_set_name] || fixture_set_name.to_s.classify.constantize
        decorated_fixture_set_name = fixture_set_name

        decorated_fixture_set_names << decorated_fixture_set_name
        decorated_class_names[decorated_fixture_set_name] = fixture_class

        File.open(File.join(tmp_fixtures_dir, "#{decorated_fixture_set_name}.yml"), 'w') do |file|
          YAML.dump(fixture_data.deep_stringify_keys, file)
        end
      end
      fixtures = ActiveRecord::FixtureSet.create_fixtures(tmp_fixtures_dir, decorated_fixture_set_names, decorated_class_names)
      @loaded_fixture_sets = Hash[fixtures.map { |f| [f.name, f] }]
    end

    setup_fixture_accessors
  end

  private

  def setup_fixture_accessors
    @loaded_fixture_sets.each do |fixture_set_name, fixture_set|
      define_singleton_method(fixture_set_name) do |*fixture_names|
        fixture_names = @loaded_fixture_sets[fixture_set_name].fixtures.keys if fixture_names.empty?

        instances = fixture_names.map do |fixture_name|
          fixture_set[fixture_name.to_s].find
        end

        fixture_names.size == 1 ? instances.first : instances
      end
    end
  end

end
