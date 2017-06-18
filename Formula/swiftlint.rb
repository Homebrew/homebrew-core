class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.20.0",
      :revision => "e1dee5179178a9fd18f58adcd63b294a0623f484"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "c4e9519233445646f5103bcef5bac8b953ccdf0e43667ec29eb8f08b1e55d219" => :sierra
    sha256 "f784216868dcd0f61b016a8b65f2214394897ed4b127142679c23d1dd341becb" => :el_capitan
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
