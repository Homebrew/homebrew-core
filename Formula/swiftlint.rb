class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.46.1",
      revision: "61c53519789452a6ef1d002617cb76e393aa2de7"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c5ee554b70d936ad2e50743071abc18cd2afc9daecaa279b92502954b2c5bf5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "280e4a16fd6c18252cb2ee7232021b45b8fba6393ba2e3f74cf62f435b76baef"
    sha256 cellar: :any_skip_relocation, monterey:       "977afd519f518fbf9e5d145e0938f17261c5dcf34bd838bc4677715e53a1d383"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce2f1f3f19922e723ce89f72a7da8dfce4399b6fca787025122c353207ce3a66"
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
