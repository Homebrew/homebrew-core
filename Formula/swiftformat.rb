class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.4.tar.gz"
  sha256 "34ecc5a04fce9f3ed63359d5f8529474eabb249a93e45d3e1df34b787b9a7899"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fd0427fdb74e0cc88da322ce2b2cd0b9e021fd286f34978b01b0bb62f9e8529"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc99c52385e32a1d2bb42625a535cac9835313e65ba84776cbe2ad49ae41167d"
    sha256 cellar: :any_skip_relocation, monterey:       "39877fc1115e6f15d20a76c30ddbb23d45f52fb95eb81382c4f4abe2b98eb03b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ead4633c1ec372b7cc6995dba2d3352691b4086f501e0346629072873bccef99"
    sha256 cellar: :any_skip_relocation, catalina:       "359cd4f2c3eea7c28f485db06dc955d8b27eabab340420a0c52931004a3ee3e7"
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
