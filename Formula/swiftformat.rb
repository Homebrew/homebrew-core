class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.9.tar.gz"
  sha256 "d1b228769df6246bd79598d0a5945c10a12bf5c76333f3ac99a22c22d8e68452"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "da13fa725076e5c485ef3fc752744bc5dcf1ae04a8185e7793d33cc06194ef4a"
    sha256 cellar: :any_skip_relocation, big_sur:       "3f1ab76e9ee194c813b44766da51d0c19760884d7915392bbb4a704f47d41997"
    sha256 cellar: :any_skip_relocation, catalina:      "a244df3c1ff9822e2f3e69f89196f74377376eb59ef7b3b3e699ea4854f7176d"
    sha256 cellar: :any_skip_relocation, mojave:        "798c29039d70c2a242edf2a21760dd7c366f9dd8ec5c32326e93c4dd105b83fc"
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
