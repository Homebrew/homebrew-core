require "set"

class Swiftplate < Formula
  desc "Cross-platform Swift framework templates from the command-line"
  homepage "https://github.com/JohnSundell/SwiftPlate"
  url "https://github.com/JohnSundell/SwiftPlate/archive/1.2.1.tar.gz"
  sha256 "c4a47411340c88dbacc87d63daf69eed12c80cbc2e1fc8c02cc8d6b2966c04b9"
  head "https://github.com/JohnSundell/SwiftPlate.git"
  depends_on :xcode => "8.2"

  def install
    xcodebuild "-project",
        "SwiftPlate.xcodeproj",
        "-scheme", "SwiftPlate",
        "-configuration", "Release",
        "CONFIGURATION_BUILD_DIR=build",
        "SYMROOT=."
    bin.install "build/swiftplate"
  end

  test do
    project_name = "test"

    system "#{bin}/swiftplate", "--destination", ".",
      "--project", project_name, "--name", "testUser",
      "--email", "test@example.com", "--url", "https://github.com/johnsundell/swiftplate",
      "--organization", "exampleOrg", "--force"

    root_files = Set.new ["LICENSE", "Package.swift", "README.md", project_name + ".podspec"]
    config_files = Set.new [project_name + ".plist", project_name + "Tests.plist"]
    source_files = Set.new [project_name + ".swift"]
    test_dirs = Set.new [project_name + "Tests"]

    def die(directory)
      abort("directory structure of " + directory + " doesn't match expected results")
    end

    unless root_files.subset? Dir.glob("*").to_set
      die("root")
    end

    unless config_files.subset? Dir["Configs/*"].map { |x| File.basename(x) }.to_set
      die("Configs")
    end

    unless source_files.subset? Dir["Sources/*"].map { |x| File.basename(x) }.to_set
      die("Sources")
    end

    unless test_dirs.subset? Dir["Tests/*"].map { |x| File.basename(x) }.to_set
      die("Tests")
    end
  end
end
