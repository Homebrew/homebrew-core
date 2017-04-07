class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.18.1",
      :revision => "ab664127d5d32d9ddd655b2cc313abe528a66a42"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "a6b1480fddb1eb2e71646cc94020b06473005461a5e3b35b39cf1bd4921d9ea3" => :sierra
    sha256 "1497b77e5c45890d620d45abf90b8dea7e81b78c1a90f7742a3d95f8c508485d" => :el_capitan
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
