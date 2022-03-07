class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.46.4",
      revision: "f3712b2b9377e5de899001aedc0ad0561c5ec686"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3cb6eea2576aa1a2f01e8b89e0f40fc03d5228270d42a36f54284c8040580b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c999d94e57930a3dc33850e1df96a55a73839200c57b143efad403c1306511f6"
    sha256 cellar: :any_skip_relocation, monterey:       "7a97992d38dac3f5c0881c7e705cfe8ac39881ba8e45bdc0a90153e3fad01cd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "48b93799c895624042e3491194022e3e157bb6fb311e0ffe0d68f3e2107229ad"
  end

  depends_on xcode: ["12.5", :build]
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
