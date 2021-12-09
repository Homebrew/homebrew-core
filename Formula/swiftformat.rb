class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.1.tar.gz"
  sha256 "7f6ec67f093df69e35b236331bcba93f3cb6c93d807bb874dda932ffcbc11a79"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c9e0d59c03ef20c160a3218dd0538f1629a6e417ff006926a981822e7127ebc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "344924164e034a532cc57a1bb0a0e6751f8ef9157671e32cfb96a39c5b121d39"
    sha256 cellar: :any_skip_relocation, monterey:       "9313dc428fd0ee222b0850c57a5449a2b2c2b59f01ff90b0f4edfa572f357dc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "cff603ec304a16944d56ce4fc6a56c7e67c1395fba33476f84d68e4bbfd15ffa"
    sha256 cellar: :any_skip_relocation, catalina:       "b8231ff96ed53eab67dd0b0adad04ac4ff7d6f72e08952d0f81fdc8db2171224"
  end

  depends_on xcode: ["10.1", :build]
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
        "-project", "SwiftFormat.xcodeproj",
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
