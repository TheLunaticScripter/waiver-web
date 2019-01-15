# Class to handle profile and actions
require 'fileutils'
require 'erb'

class WaiverProfile
  def initialize(failed_profile, profile_path, profile_name, profile_version, source_profile, hab_origin, template_path, controls)
    @failed_profile = failed_profile
    @profile_path = profile_path
    @profile_name = profile_name
    @profile_version = profile_version
    @source_profile = source_profile
    @hab_origin = hab_origin
    @template_path = template_path
    @controls = controls
  end

  def build_profile
    puts "Intialization of Waiver Profile"
    FileUtils.mkdir_p(@profile_path) unless Dir.exists?(@profile_path)
    %w(
      controls
      habitat
      libraries
      habitat/config
      habitat/hooks
    ).each do |dir|
      FileUtils.mkdir_p("#{@profile_path}/#{dir}") unless Dir.exists?("#{@profile_path}/#{dir}")
    end
    puts "Creating habitat plan for #{@profile_name}..."
    habitat_plan = ERB.new(File.read("#{@template_path}/habitat/plan.sh.erb"))
    plan_path = "#{@profile_path}/habitat/plan.sh"
    FileUtils.remove_file(plan_path) if File.exists?(plan_path) 
    File.open(plan_path, 'w+') do |plan|
      plan.write habitat_plan.result(binding)
    end
    %w(
      /habitat/config/inspec.json
      /habitat/config/settings.sh
      /habitat/hooks/run
      /habitat/default.toml
    ).each do |file|
      FileUtils.copy_file("#{@template_path}#{file}", "#{@profile_path}#{file}") unless File.exists?("#{@profile_path}#{file}")
    end
    test_file = ERB.new(File.read("#{@template_path}/controls/tests.rb.erb"))
    test_path = "#{@profile_path}/controls/tests.rb.erb"
    FileUtils.remove_file(test_path) if File.exists?(test_path)
    File.open(test_path, 'w+') do |t|
      t.write test_file.result(binding)
    end
  end

  def update_profile
    # TODO: Add method to update profile instead of creating a new one
  end
end
