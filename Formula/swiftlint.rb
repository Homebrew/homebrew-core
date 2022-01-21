class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.46.0",
      revision: "17779cbfd41bf075a7f57c0c786fef41284e9bec"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddefff405a8c4721e7dfe4de28b461a86bac9eeaf3779bfd1626e314e3d8f36f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98b0939a4c4c207f58f887d82efd1f0f5e32e75583b75fffa7479bdc61857261"
    sha256 cellar: :any_skip_relocation, monterey:       "9bad2b2d8af3dd1fc59c81c84636024566ab4aeb9b4fedcc9116497083ad9f33"
    sha256 cellar: :any_skip_relocation, big_sur:        "f959ec12dbb8eb32cd7379eb8545739a241acfcdf9a56042553a401cab328309"
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
