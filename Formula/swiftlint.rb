class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag      => "0.34.0",
      :revision => "08946e65e5888797e588ecb23f80b16a129bf4bd"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f406bfed22a5f973c1e38788080eab97e8576bfe7d7cd58a30a8bb19a0eeb5a8" => :mojave
    sha256 "3bbcaeba385f2d8b8e0353c33079aa650a410f9c4eb9184c439154906ef4edc0" => :high_sierra
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
