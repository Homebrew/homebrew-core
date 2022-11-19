class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.50.0",
      revision: "cdd891a4a29cfd3473737857385f79c972702293"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de8e0f6ec95841ed542610ac059c48d2abc4e79dcf0a480fde6f28ec93d407ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82afefdb2928124cbcbb0bf0137be3ed5852e71d94c41c7fee496f8af310ce20"
    sha256 cellar: :any_skip_relocation, ventura:        "3f91d1e36f15aa978a5f1bb86f415f69359b88f36932517a472a3d99dd8bed39"
    sha256 cellar: :any_skip_relocation, monterey:       "b96f8954899cffb034167b1c06974b0d0c9a96fbe073f61fcb5700568a9b070a"
    sha256                               x86_64_linux:   "a65f5f294d1520d6ccc5547e1d569bc06a0166bd3e734d24f7e225eb91ae4f74"
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
                 "Files should have a single trailing newline. (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}/swiftlint version").chomp
  end
end
