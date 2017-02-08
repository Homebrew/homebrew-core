class Swiftplate < Formula
  desc "Cross-platform Swift framework templates from the command-line"
  homepage "https://github.com/JohnSundell/SwiftPlate"
  url "https://github.com/JohnSundell/SwiftPlate/archive/1.2.1.tar.gz"
  sha256 "c4a47411340c88dbacc87d63daf69eed12c80cbc2e1fc8c02cc8d6b2966c04b9"
  head "https://github.com/JohnSundell/SwiftPlate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f2f6159e6de0243545bc2f18eca9618a33ecc56995dcd92db46b4298c6eb372" => :sierra
    sha256 "80484682a0aff82ec7b34d4b4beeecbf1cfed673ab5b3cd1ad2af2d3fcbbc020" => :el_capitan
  end

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
