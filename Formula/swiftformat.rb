class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.3.tar.gz"
  sha256 "1cbab865086f715e544e0cf67d638631444d95bb87d365d75eef16efbc763a49"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", shallow: false

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "35f197cd20e7112460002fd08aa1c5b8902cfec22b1065669726c23820f8bc5b"
    sha256 cellar: :any_skip_relocation, big_sur:       "456fcbe08ec3a57d9730fa4ad70e36c53f74fc64fc5f1cae1b25dfc43f693480"
    sha256 cellar: :any_skip_relocation, catalina:      "390c8307574e61a372e2fde3f6d0fdfff7401683b8875f22ba6712b154092a64"
    sha256 cellar: :any_skip_relocation, mojave:        "07b289fad1b3fae73824a483cae12233b09c5bacdba7d1ee921b99940af77baf"
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
