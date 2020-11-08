class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.41.0",
      revision: "d91c2179bb55111790e7053c039d5d7a600dfa3d"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84368120d02e9a22515d4fdfe852dcdddcfa47f8f688e5d0aa6eba837d52d890" => :catalina
    sha256 "42de59d77fdd150558306b024d1cceb757da3d83aa3c03fd985636e24ef8ab9b" => :mojave
  end

  depends_on xcode: ["10.2", :build]
  depends_on xcode: "8.0"

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
