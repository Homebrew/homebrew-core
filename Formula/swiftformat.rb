class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.3.tar.gz"
  sha256 "9ba69aff222e89d75491c974f4fba157fab2beea98d6d63d846b2d197f494f68"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2279db95259ddbc7ad83e47f5bbf8c308db55b74d5464ac79a027bd33138b023"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f6bddbef7d750d6ed546ed5decd4d54d439f16009491bdb4e4999c99d877bcf"
    sha256 cellar: :any_skip_relocation, monterey:       "190bf822a188ec8e8be754de2fcd34166ffb07bbd40d67385653d898a251b167"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe294ff0fa69548876a70ef7aaf30b7221a43adc9f75f7c157c6f881089da6eb"
    sha256 cellar: :any_skip_relocation, catalina:       "2a174bf9c47a070b1fcaa32c066cd7c82604fc428db952f11c9bf1e4448c567a"
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
