class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.47.0",
      revision: "e5791ec16ccc1560840c46ed57122c888167d740"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1769be16e4949447e8d3e16d742cccc48e31706d1bbab147669e466edfe2380f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f074570b059e6eda84bcb7185d0188dd3b69f3e2eb40e7a9be15653db12b686"
    sha256 cellar: :any_skip_relocation, monterey:       "82ffbf311c85957735e6ed5dcb9c0434e3dc5cad24922b210f60e06e72f1a1ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c6f5c0a66a943cf223caf8e1f42260bceadd7ea80611071587d774714ca227f"
    sha256                               x86_64_linux:   "bff98f2e2fc9b05f8653ec62cbe50593b604ca8b39a40bd8cbed5bd9cb050f1a"
  end

  depends_on xcode: ["13.0", :build]
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
