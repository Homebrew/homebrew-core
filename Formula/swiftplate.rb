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
    system "#{bin}/swiftplate", "--destination", ".",
      "--project", "test", "--name", "testUser",
      "--email", "test@example.com", "--url", "https://github.com/johnsundell/swiftplate",
      "--organization", "exampleOrg", "--force"
    assert File.exist?("test.xcodeproj"), "Failed to generate test.xcodeproj"
  end
end
