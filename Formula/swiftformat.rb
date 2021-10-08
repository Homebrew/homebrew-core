class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.48.15.tar.gz"
  sha256 "dc2c0b01c0551863d451bc0aac38f8709b808a40f28d1f6890abaa635481d29c"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "054c6410409c314f542a1cbdf346b97739cba7c428782102ee7da769a4a020f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d8a45abe86cd14d39a878da61222290d5636c6ce83ca723d279872d74f465c3"
    sha256 cellar: :any_skip_relocation, catalina:      "31e3cb1ebb834e293ddfbf5fbf50ae0a82a68f8c50a0651e91ff3a46af42b320"
    sha256 cellar: :any_skip_relocation, mojave:        "05e29fe832b94c95401105ddc30d8aca17577c4fc1fef4681f68d66fe72bdaa9"
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
