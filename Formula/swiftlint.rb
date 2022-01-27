class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.46.2",
      revision: "b4a54f32df66008d30f0229446831cb823576c42"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9db36183ea18b36a94add8be40a93a2d555afdfa2e011dd17eb354455a4743ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4345d39ede1a8aee254ec2c94bfa15c823437069d606fc62837f10c994c21eb"
    sha256 cellar: :any_skip_relocation, monterey:       "0efebf1269594c8d62c6b5d884b4bc786bfe28dbf33340564fe44952bbc131f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "eba1dd7b36b7e11c09ffcca0387228414d472ee77a225c117dc06487eb1fdc55"
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
