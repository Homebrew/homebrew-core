class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.40.2",
      revision: "9ab72060b6d57d62a601250c15879ada088a2d99"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d24f5ffdfc80f1027a9a0dbe03cb519f33e4ae395eb0ed0cb79451df665d45b" => :catalina
    sha256 "696a974b205a589fed4b1fdb48081f630a67181f3d959636ac4d0d10216f6320" => :mojave
  end

  depends_on xcode: ["10.2", :build]
  depends_on xcode: "8.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
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
