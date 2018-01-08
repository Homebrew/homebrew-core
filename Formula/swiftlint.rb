class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.24.1",
      :revision => "7ad77df690a756079d84be35c0ca6407551a35c6"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "1dd3913989f53eb6bb508c6c390dbeee48beffa308104bd67419716e8dc3636f" => :high_sierra
    sha256 "5197fef0384f3a47fbd4ebb5fc9288558ce6a7935eb5aafcc1fbd1682ef66d65" => :sierra
  end

  depends_on :xcode => ["8.0", :run]
  depends_on :xcode => ["9.0", :build]

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
