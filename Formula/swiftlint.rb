class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.16.1",
      :revision => "16ca04905c769657c22e3a02435992b41ddfdc52"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "4f7826cd02501f11a39daf41a5752a1c4df4d047416d856c959378212748d695" => :sierra
    sha256 "ff0453102251cd2b3e5d8c7d1cc951818ee4e4a2e6f0e9b635892dc1c32fdb41" => :el_capitan
  end

  depends_on :xcode => "8.0"

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
