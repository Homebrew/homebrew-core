class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.43.1",
      revision: "180d94132758dd183124ab1e63d6aa8e10023ec2"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e1b633e61793b924f5875e4812b49184c91fc6580bfd497ab650fe13fbbe8d8f"
    sha256 cellar: :any_skip_relocation, big_sur:       "90faabe65db0f6bc43c3752b3b6d541e7e23cd0f368035dcef57503d74ed9581"
    sha256 cellar: :any_skip_relocation, catalina:      "c1396dec887bf6d7986c35f38101955fb1a5c527ad4cd459174b3841dfa62239"
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
