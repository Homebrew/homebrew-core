class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.43.0",
      revision: "da2ca76953d6465309978053925c1849328e37f6"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "40380ba3f38a0b1d3abcd3a091f4962f82e8140cf3fc19b46851a3fed9fb22ea"
    sha256 cellar: :any_skip_relocation, big_sur:       "2beddd14fbfe3299c7f3172052c91c132b7cfc61f9846caa01b0c9ae088b3512"
    sha256 cellar: :any_skip_relocation, catalina:      "52a94e468e6b409912c528f05eb5148d65d896895d7037f6cbe6760c1557f679"
  end

  depends_on xcode: ["11.4", :build]
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
