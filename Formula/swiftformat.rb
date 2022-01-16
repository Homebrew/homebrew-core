class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.2.tar.gz"
  sha256 "a9441633ad6dbf2cb8aa9ad7e5f29027373a4b0b7c5d6496682edca378070480"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c43caffb4d2cf9546b0a8fa732ffe5d95b1b1fd7ab03f1c5da39c8e7a0e8ecb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad0ce5fc15fe1d339d366ece18694fdc1d14021684462a126ed20b537a1a9bf5"
    sha256 cellar: :any_skip_relocation, monterey:       "33652b8015d31dbe45e00bdc598f1b228cb63c7083b90137fdec66318a88010f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0ad88e5594a6a3e5a35834a9a22473a05511375942dbb046d1085cc537d60b8"
    sha256 cellar: :any_skip_relocation, catalina:       "564f5daf9cd82407843aed590bd4190f3e5aaa73a30b3bc8ae07135f1319ac97"
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
