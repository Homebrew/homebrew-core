class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag      => "0.39.2",
      :revision => "b1c72069cafa6cdebfb9274806cd976c54d8dde5"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "32f9e5e37190e81856eff49c2118c04d1995110b509f0a4997e211c9f939919e" => :catalina
    sha256 "c4fc10277d46c406277491003e5d5bbdfe526890c39b30eb924749696ed56d40" => :mojave
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
