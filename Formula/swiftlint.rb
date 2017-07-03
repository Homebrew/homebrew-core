class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.20.1",
      :revision => "d8f5a316f29077cd22f7d129e8bfaf4f4238d6f1"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "95b1e72edaee179d274046bea8b9ee996e7896fbfbeea882d11c7a705d6f1d03" => :sierra
    sha256 "d54e7f8631dc1f4e59a9d432e0a2164b63cb6df2a48a5030706761d3b4064630" => :el_capitan
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
