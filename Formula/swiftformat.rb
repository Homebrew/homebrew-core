class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.47.6.tar.gz"
  sha256 "40a1edd87d4ce8b8d36c39a519c29ec9272ffa57608d43ac0f9e58d136095be1"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "04f7b735991bc34aee3bad57cca323592f220bd91216a03a47b8ca6e793db990" => :big_sur
    sha256 "25547a2900437580191655b1ef9e13fb991fd81089d269dd2cfdc252e4a0749e" => :catalina
    sha256 "2851d8a09ba07c3f43d359c1ca8870ce895faf60776bec1903c7be8952c9f97d" => :mojave
  end

  depends_on xcode: ["10.1", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
