require 'xcodeproj'

module Xcake
  module Generator
    class Project

      attr_accessor :cakefile

      def initialize(cakefile)
        self.cakefile = cakefile
      end

      def output_filepath
        "./#{self.cakefile.project_name}.xcodeproj"
      end

      def build
        project = Xcode::Project.new(output_filepath, true)
        project.setup_for_xcake

        build_xcode_build_configurations(project)
        build_targets(project)

        project.save
      end

      def build_xcode_build_configurations(project)
        cakefile.build_configurations.each do |b|
          build_configuration = project.new(Xcodeproj::Project::Object::XCBuildConfiguration)
          build_configuration.name = b.name
          project.build_configuration_list.build_configurations << build_configuration
        end
      end

      def build_targets(project)
        cakefile.targets.each do |t|
          target = project.new(Xcodeproj::Project::Object::PBXNativeTarget)
          target.name = t.name
          project.targets << target
        end
      end
    end
  end
end
