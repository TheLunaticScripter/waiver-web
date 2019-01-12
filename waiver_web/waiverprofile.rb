# Class to handle profile and actions
require 'fileutils'
require 'erb'

class WaiverProfile
  def initialize(failed_profile, profile_path, profile_name, profile_version, source_profile, hab_origin)
    @failed_profile = failed_profile
    @profile_path = profile_path
    @profile_name = profile_name
    @profile_version = profile_version
    @source_profile = source_profile
    @hab_origin = hab_origin
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
    habitat_plan = ERB.new(File.read('../../../templates/plan.sh.erb'))
    File.open("#{@profile_path}/habitat/plan.sh", 'w+') do |plan|
      plan.write habitat_plan.result(binding)
    end unless File.exists?("#{@profile_path}/habitat/plan.sh")
    
  end

  def update_profile
    # TODO: Add method to update profile instead of creating a new one
  end
end