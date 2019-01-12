# Class to handle profile and actions
require 'fileutils'
require 'erb'

class WaiverProfile
  def initialize(failed_profile, profile_path, profile_name, profile_version, source_profile, hab_origin, template_path)
    @failed_profile = failed_profile
    @profile_path = profile_path
    @profile_name = profile_name
    @profile_version = profile_version
    @source_profile = source_profile
    @hab_origin = hab_origin
    @template_path = template_path
  end

  def build_profile
    puts "Intialization of Waiver Profile"
    FileUtils.mkdir_p(@profile_path) unless Dir.exists?(@profile_path)
    Dir.chdir(@profile_path)
    puts "Creating profile directories"
    Dir.mkdir('controls') unless Dir.exists?("#{@profile_path}/controls")
    Dir.mkdir('habitat') unless Dir.exists?("#{@profile_path}/habitat")
    Dir.mkdir('libraries') unless Dir.exists?("#{@profile_path}/libraries")
    puts "Creating Habitat plan"
    Dir.chdir("#{@profile_path}/habitat")
    Dir.mkdir('config') unless Dir.exists?("#{@profile_path}/habitat/config")
    Dir.mkdir('hooks') unless Dir.exists?("#{@profile_path}/habitat/hooks")
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
  end

  def update_profile
    # TODO: Add method to update profile instead of creating a new one
  end
end