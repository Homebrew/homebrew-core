class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.2.tar.gz"
  sha256 "7c0bacf508c37d686c346226e98519a0b569a3795e4a0acb88bd4922ad78e149"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "937b21c64f3aec2eaf9d0234f681013e1026f3110bafac9348a58e893305c266"
    sha256 cellar: :any_skip_relocation, big_sur:       "e5217aee36051fd378912b4620786b5892ec4b69343e06f6b94747ab08e1c0ea"
    sha256 cellar: :any_skip_relocation, catalina:      "203eaac0a2c2f18121937d3c065a867a748e7539f8a716d8e55358d626850ec3"
    sha256 cellar: :any_skip_relocation, mojave:        "cc3176e0ed768de2ab13ed28cb41c6efa010382fa2862896c474ff54ce385bfa"
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
