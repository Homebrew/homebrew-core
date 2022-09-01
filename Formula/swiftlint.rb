class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.49.1",
      revision: "57dc1c9532d660ff547dd8ba2176ad82c1175787"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a886a9c1fd8ab7690e6dffb169f58fe2916ae7fff655b152df8cc92cdf5c1ec"
    sha256 cellar: :any_skip_relocation, monterey:       "4bef317ca7533b0c137ba2dfe4786aff6857b9803177a0b6ef7056fc5933f95e"
    sha256                               x86_64_linux:   "aab347f1816493951bb0ffa741ec954448439d1c3a207be95025b22d8f2b563a"
  end

  depends_on xcode: ["13.3", :build]
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
