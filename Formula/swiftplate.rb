class Swiftplate < Formula
  desc "Cross-platform Swift framework templates from the command-line"
  homepage "https://github.com/JohnSundell/SwiftPlate"
  url "https://github.com/JohnSundell/SwiftPlate/archive/1.3.0.tar.gz"
  sha256 "edd0329dd04e579e17b71d3b9624781fda2fdb046eb9a5ea1a7a391144b900a8"
  head "https://github.com/JohnSundell/SwiftPlate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "08c2ec29bd298efa3c3634c218667307dcd0bac874bc23a80e04262749d4e30b" => :sierra
    sha256 "60af116ef0834a8e610288caf3ed28d53bf9144cbb3637e6836d55a617347c9a" => :el_capitan
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
