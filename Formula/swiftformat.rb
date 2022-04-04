class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.7.tar.gz"
  sha256 "141e345fd654997bcf501d085be915e2e5386e8d00db08c4d53205c2438ff117"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29da840cd2b4566c9e6c7ee924a013ce1cae248865bb5bc8dd908d398f6f0a2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc5b342a0c4b3164463ed7aa72b066c976a06d71bb12008239a75ef72d6c1354"
    sha256 cellar: :any_skip_relocation, monterey:       "df696ff45308581c51099fb53ff0bbd315cd8e912586437686db61bf2bc0bcce"
    sha256 cellar: :any_skip_relocation, big_sur:        "defcc3402f0095a3bbbc88c0e56c20941888f3e4366e197726c2799646a9ff76"
    sha256 cellar: :any_skip_relocation, catalina:       "8a1447838114d787f9dff79c5c7d4125aa186f2d093de96b3d6269f0f1d12976"
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
