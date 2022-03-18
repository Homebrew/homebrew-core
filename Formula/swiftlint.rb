class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.46.5",
      revision: "e8ef21fef61f12536964c4e3cf6d5a6e3ad81e49"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6285b488bb88cc6f2f2a989cfb56934f901d9491d222679d21f8b71c6bd3202c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffa98c60976449b926a6f62c954a6def1f83d0f44bb027729876e51a24308876"
    sha256 cellar: :any_skip_relocation, monterey:       "9104eafbbce0f710f063f2016a991971067f94f0428c606895ecd38dff0b622b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ef668df8a55c1c130782677d4aaf4ddf217c9143416daa2a71943ec6acdff19"
    sha256                               x86_64_linux:   "c036d6153580d5a6b35ec4e52bdb6619ab3c889a6d7d09a463a497365ad711c7"
  end

  depends_on xcode: ["12.5", :build]
  depends_on xcode: "8.0"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftlint"
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: " \
                 "Files should have a single trailing newline. (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}/swiftlint version").chomp
  end
end
