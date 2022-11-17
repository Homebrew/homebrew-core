class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.49.1",
      revision: "57dc1c9532d660ff547dd8ba2176ad82c1175787"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de4f931704cfdbd7300a74d8f0ef807394f3366ed1d3d59eabb87edcefa926af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d983879e2d9ea075bf80e223da5adb258f01d9fab4fc6f71f83c4add80490290"
    sha256 cellar: :any_skip_relocation, ventura:        "509e34c1cfdfda9dace98481bc42cc57575c78ffe7711d381b851c330ee4d8b8"
    sha256 cellar: :any_skip_relocation, monterey:       "73a9664d8a62c7b5d506a70bf100e0289795df04ece6df12f0b77651e497d42b"
    sha256                               x86_64_linux:   "705904346a73422be8f053d7b1c413e5d18623bd7244cb33d188d921a072e600"
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
