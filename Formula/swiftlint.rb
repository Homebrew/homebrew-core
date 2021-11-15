class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.45.0",
      revision: "99465e659fb91facab5b1d3c0f9229176d086bf1"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5acfc58c5c401447183ac281e264c3f7724eeda5a708d49cb20a1618a311184b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85a35161284914d468563c898babfefcb4010d8de96b843a7f36ad8b55bf996a"
    sha256 cellar: :any_skip_relocation, monterey:       "52444cc37d10ed0db9edeb4e3500617492b08d768b13198ddb1c6b200f96bc29"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7213df813a99fa4a310a15f7c4212bf3aad8955adadb2621c86ffdacda00a99"
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
