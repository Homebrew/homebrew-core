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
    sha256 "ea458356bba88a0fd9f74e4c4676663ffc43b648138dd7d537ecba2ced7cf85a" => :big_sur
    sha256 "3e6cbf8f6968fd1f5f08f602ae4feb3df4d42eda57b33395f0599fbb6a707b1e" => :catalina
    sha256 "0f5a693a08771785c53265863fe234823e5819032bf0971207b0b205d357a464" => :mojave
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
