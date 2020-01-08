class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag      => "0.38.1",
      :revision => "6f6c9fed8c9eba586c2f1acb751b0f769ee4994f"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3530bda78d9c58545d3b877788456a5a70c0d8091bc2dc2cb017e9c829a034dd" => :catalina
    sha256 "f01c400c89a89022e4249fb241649bcb3e6c6e9b1e9b43800411f384d774684b" => :mojave
  end

  depends_on :xcode => ["10.2", :build]
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
