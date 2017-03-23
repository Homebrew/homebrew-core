class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.17.0",
      :revision => "cc9e81754f2ef156c832b1f322d3482765ee0e03"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f2133f1c605352b9fba84bf64bfe969fdb64fdd4c8f711f2e3b2b6cc17c12da7" => :sierra
    sha256 "4a3da537c3b0c39c01b626060f04a80171acfa092402b4f10599ffe6d2b926c5" => :el_capitan
  end

  depends_on :xcode => ["7.0", :run]
  depends_on :xcode => ["8.0", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "#{testpath}/Test.swift:1: warning: Trailing Newline Violation: Files should have a single trailing newline. (trailing_newline)",
                 shell_output("SWIFTLINT_SWIFT_VERSION=3 #{bin}/swiftlint").chomp
    assert_match version.to_s,
                 shell_output("#{bin}/swiftlint version").chomp
  end
end
