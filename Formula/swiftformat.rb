class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.16.tar.gz"
  sha256 "baea2b0fc66afa1db17404c5cdedb536371e107627e41be6b55e44642c4688bb"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee290525c30d75f3a11593e70152cb8a0991895f84997ed29db9b1d37f669d28"
    sha256 cellar: :any_skip_relocation, big_sur:       "66f58f8fc6eeae201725827085b36d155cbc76f83911e8e2c1e1b3328aada916"
    sha256 cellar: :any_skip_relocation, catalina:      "4bc7d316a2eba1953a0a2fdd8ecac830a0d3ab18e13db5bab755a21685c2aeac"
    sha256 cellar: :any_skip_relocation, mojave:        "30c8d266768c76727c7b4a9e4e78a64d43ba9e60550f0a83984daa60a6293090"
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
