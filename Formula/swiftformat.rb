class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.9.tar.gz"
  sha256 "0d015ea7d9e37f5410bfd0f788c719ab566eba9160f3a977388318b5c500c75c"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bacd0dc8f488fd7909252467eaf16dcd339468857aea13a3643f7e0efd7715f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bc39a57d110f727993aa556cca5cba5549d536367bc12f25b56e25c4fdfa194"
    sha256 cellar: :any_skip_relocation, monterey:       "739d230372dd797d5cf5a0586156068ecb5965878550a67b5ca56ccdf2799557"
    sha256 cellar: :any_skip_relocation, big_sur:        "22080bdc75b03f5926d68fb248fc401d6a94876205ce03663a8950644b0e41e6"
    sha256 cellar: :any_skip_relocation, catalina:       "d4cda88cf3bef7b18e960197b8db4826f234e3b3434ba902c3924c37b9040fe8"
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
