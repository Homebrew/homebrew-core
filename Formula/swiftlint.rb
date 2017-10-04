class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.23.0",
      :revision => "d1cc1286604d45e25c75724ba36cd5643db76f18"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "4058e4251500e8aefd4b1269ce08a9280468a9a4d7521d152b54d96d011c6e96" => :high_sierra
    sha256 "ef5593b0b26311ff3a6a771e6bf15ddf0ce5eab8b67189c1a07b073bf02e595a" => :sierra
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
