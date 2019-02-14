class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag      => "0.30.1",
      :revision => "b2d428a4e24abd4f7cfeb0cd610b1656fb48c4a9"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "66a31cfbe346a49835e399f43016ccba311effc82bef9b29a8f9afd1bf4f0db3" => :mojave
    sha256 "29624ff8bae7ef8c2608340c1df72a0b3c34cc8a31bb070f68e74f01eabc36b9" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "8.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: Files should have a single trailing newline. (trailing_newline)",
                 shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
                 shell_output("#{bin}/swiftlint version").chomp
  end
end
