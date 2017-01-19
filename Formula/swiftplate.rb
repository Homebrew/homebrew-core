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

    required_files = {
      "." => ["LICENSE", "Package.swift", "README.md", "#{project_name}.podspec"],
      "Configs" => ["#{project_name}.plist", "#{project_name}Tests.plist"],
      "Sources" => ["#{project_name}.swift"],
      "Tests" => ["#{project_name}Tests"]
    }

    required_files.each { |dir_name, files|
      expected = files
      actual = Dir.entries(dir_name) 
      unless (expected - actual).empty?
        abort("directory structure of #{dir_name} doesn't match expected results - #{files}, #{actual}")
      end
    }
  end
end
