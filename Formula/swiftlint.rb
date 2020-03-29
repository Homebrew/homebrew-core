class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag      => "0.39.1",
      :revision => "8f22943ca1340a95e5aeb5513b62a9f0766c0f74"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c51f9a46a0ab28229460afd1037825bf1bef6b577113303057602487a898553" => :catalina
    sha256 "408d3baeeb687da9cb753abf154835d71672eb29f1288538e5fa576f6d8880d1" => :mojave
  end

  depends_on :xcode => ["10.2", :build]
  depends_on :xcode => "8.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: " \
                 "Files should have a single trailing newline. (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}/swiftlint version").chomp
  end
end
