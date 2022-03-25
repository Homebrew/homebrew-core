class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.47.0",
      revision: "e5791ec16ccc1560840c46ed57122c888167d740"
  license "MIT"
  revision 1
  head "https://github.com/realm/SwiftLint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01c48ad5542d38eb36d1234788a0b56f50ecf9893285f51add49615d29063e3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02c38f3a7ebc90670d84cd3c4de69c0fb77472b1100ae0861d21dcaf79c9f921"
    sha256 cellar: :any_skip_relocation, monterey:       "3607ae5dcc4341e1811b93a12a37ea1959bc08cb63146a98d227451575d74daf"
    sha256 cellar: :any_skip_relocation, big_sur:        "b77cf6fdc6bfd279e98dac9bd5311b80c5d45b88f61b227ddeddc4553b692f8b"
    sha256                               x86_64_linux:   "9a614b809a76ead76f03e7ec0a8eab03688f095964ace39a436c247b7cfe0b28"
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
