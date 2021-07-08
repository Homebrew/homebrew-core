class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.8.tar.gz"
  sha256 "87adb0533ac5aae5cde092c2ae6e0e926a0948eea7a5cdebc72b4640ed8ef23b"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "19689caf388e4312dac96160252a1022ec15eab1b2b85d1ad7d29546354bf786"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce59b4c7f2c22dd16aef709691aabde52dcca105991f5aebcf17a6e9cb48b57b"
    sha256 cellar: :any_skip_relocation, catalina:      "c69c3ef618f63607d0b2e6423d1443ba60b254638f77ca2e1e4bca38ba964498"
    sha256 cellar: :any_skip_relocation, mojave:        "35a56eb57a8582675bbd04a07705eee042dbf5f9da060c3e40d3199686198d62"
  end

  depends_on xcode: ["10.1", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "-configuration", "Release",
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
