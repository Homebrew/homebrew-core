class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.21.0",
      :revision => "e8112184430baafef8f3e03e9dc1e28bdf519001"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "6f7414d4065c79eeedf4e1bdf54c932256d2353a8b5b767a3cf05444dd59432b" => :sierra
    sha256 "17da84902560bb1d7e936c5ea3d6618e38b3995b9185d1c06c09d0775d0967e8" => :el_capitan
  end

  depends_on :xcode => ["8.0", :run]
  depends_on :xcode => ["8.3", :build]

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
