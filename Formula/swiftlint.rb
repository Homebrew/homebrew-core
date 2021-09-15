class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.44.0",
      revision: "e820e750b08bd67bc9d98f4817868e9bc3d5d865"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5b27f5c1768430edfec780297b2bf457b32d461af972d25d04765c2fe5297cd7"
    sha256 cellar: :any_skip_relocation, big_sur:       "4762b41abd8fdb5a4c2ceb187cede334cee842729f7b07827306e9018f759b72"
    sha256 cellar: :any_skip_relocation, catalina:      "30a53585357da5ada927a71e3ecd03609e6089e8343521e0f8757bcb7f09483f"
  end

  depends_on xcode: ["11.4", :build]
  depends_on :macos # Depends on Swift.  May work on Linux once a Swift bottle is available for that OS.
  depends_on xcode: "8.0"

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
