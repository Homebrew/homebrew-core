class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.24.2",
      :revision => "7bf32346cc1f0b3f9c48d222ac5070e89e6d30ce"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d84c034454ffb1c94780bdb06a2c3099611ead956996c3003c5a2231dc9bb98" => :high_sierra
    sha256 "e4f5afd5db515f7b1a45a5a2a94d772a0380a013931b2cd57f17f3d78ee4d209" => :sierra
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
