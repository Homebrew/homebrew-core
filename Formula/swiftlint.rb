class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.42.0",
      revision: "d53fc2664df92ef322bfa9ce5238d34f1461526a"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a0540f0ff6cac2da0a51672db7963aef71cc58954c34791e9b01dafd63c5898" => :big_sur
    sha256 "a9cf09a414fd3b8a5cb3d94e682a725f654a4d1caef19497a500d6dbb926ba7c" => :arm64_big_sur
    sha256 "e9023ed754eb8cb78a9f2b469a90875ca42a7afffd3e96f8142252e81d889793" => :catalina
  end

  depends_on xcode: ["11.4", :build]
  depends_on xcode: "8.0"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftlint"
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
