class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.46.5",
      revision: "e8ef21fef61f12536964c4e3cf6d5a6e3ad81e49"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cd894ac07d206debaf671a9cd7e118dc643ee1512f817972868819d0995a862"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ad2cd829e34c31ee3a5176ca700c331dce4b55a68b57d0c19d0f70ac3145caa"
    sha256 cellar: :any_skip_relocation, monterey:       "898f3b7788096d108d4d3720b69233405f1e3426bbd2496ee17694248486c7fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "e306c9ad9fcaca6a27278d9a26dcef3fd9e9cfdfde7e1f6b16dc082de564429f"
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
