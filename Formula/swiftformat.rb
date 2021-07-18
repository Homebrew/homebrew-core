class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.10.tar.gz"
  sha256 "00c4643e79b8d2e699635ec34cce53b1e9a10cd599c384cba1e140887857ba6b"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4687b1109421980f9c0d8558dafb5feca3af8b264ad2a8637ad243331d4dcc42"
    sha256 cellar: :any_skip_relocation, big_sur:       "4405a3fe6d770321b3cc11a55041b61ae0875a2bb8f2b10b056485d7dec2fdfc"
    sha256 cellar: :any_skip_relocation, catalina:      "14d57ba4c8370864983e6a352b6cc926b94aa0d93da09df3f0a8252bea02bc04"
    sha256 cellar: :any_skip_relocation, mojave:        "66143cfa8d7a16cd7e4bb17bd425124dfa4e58f8bf537994c1347aa50f5554d8"
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
