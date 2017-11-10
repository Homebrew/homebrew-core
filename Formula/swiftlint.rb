class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.24.0",
      :revision => "06ece1ea8dbeb3bc421e54f907e906cac32038d5"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "8c1b479be65f331dc3f62fc8684bcdcc5a3c63c0b2b2a5a5904aa81ab0147cb2" => :high_sierra
    sha256 "7ceccc5de92348c84f2bae7348b647a100a2fb0734bb3e24f7159a45f418fb6c" => :sierra
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
