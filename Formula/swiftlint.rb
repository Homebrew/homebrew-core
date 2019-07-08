class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag      => "0.33.1",
      :revision => "ffd08047464c78511ba3e8d0de4b2edd2ffa93b0"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0547c3035c16a9d2002488e6c975d005944f2f278b27be90e110fea1c3ee329" => :mojave
    sha256 "4ddb2a29696b22037332e4d6b68478937ce116d18fec139f2667d44da4c81cb6" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "8.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: Files should have a single trailing newline. (trailing_newline)",
                 shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
                 shell_output("#{bin}/swiftlint version").chomp
  end
end
