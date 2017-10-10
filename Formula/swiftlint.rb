class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.23.1",
      :revision => "c34c5c164954132a87e90d2312a74826a54487ed"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "498bd4c3e6ee62d797384086b295bed0513d2a15b3bed9ff396b3f965780c3cb" => :high_sierra
    sha256 "3f32ad5607f3484b203a9f72a2552664667d8e449d57194ea02e287b903c58bd" => :sierra
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
