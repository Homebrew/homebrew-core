class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.52.3",
      revision: "117405ce36cf364ece2c7aaf9ee7afed7efbabcc"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "861db4b30acfbe01f2131fe1db1e0e79e8c923cb42792ffb039fa0255f83b290"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45ffc66e15502ac98d8b62b96ecea02ed17e06a9742870fdbe88b1a24fcd3ef5"
    sha256 cellar: :any_skip_relocation, ventura:        "711f1e0aff06c4b0d5a524422fde4997065f9b9d120dcfbbab9ceea2f7e9839a"
    sha256 cellar: :any_skip_relocation, monterey:       "b90451b4883724bfd115b0022c90f317d2f5ce7f8cc6b3e39c05620ac06c7b68"
    sha256                               x86_64_linux:   "3971eb07f06e8180f7a524d1e972e4e14864b9f3d5b5bddd4328f7d347bc2907"
  end

  depends_on xcode: ["14.0", :build]
  depends_on xcode: "8.0"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "swiftlint"
    bin.install ".build/release/swiftlint"
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: " \
                 "Files should have a single trailing newline (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}/swiftlint version").chomp
  end
end
