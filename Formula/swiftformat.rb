class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.5.tar.gz"
  sha256 "8c02c1c61c6a6ad37182d72f2f9f6bf193f4f3aea84540795f0901f472dff8d7"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d85e28a31b1b0c3120d796f9dec0eb001369adb5166371f2dcb16bd9972ddc05"
    sha256 cellar: :any_skip_relocation, big_sur:       "b8572efabc3aa0627898ae23fbb7847e5e007fb631217df54d30ac5a2b52f82a"
    sha256 cellar: :any_skip_relocation, catalina:      "384c3e7c2ce67b2b291774c17da54d0f43ee3b93db3d5f2254c7bbdbbb42213e"
    sha256 cellar: :any_skip_relocation, mojave:        "5093e230eccbc34e1d0782ba558bcebb3959af7cb2909a6dbefb0d8db88b4242"
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
