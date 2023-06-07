class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.52.2",
      revision: "34f5ffa7f706ed2dfe11bd300e5197e8878e3856"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cf375ddb9588a5edc7612a05ecb73bde1d8e0ca275585c4795b2b3a45b6e5ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bea6bfec66796dc30cc6d73a81b5d2f4acfa7e4b87c2275a1d0c5cf0bf674757"
    sha256 cellar: :any_skip_relocation, ventura:        "4bcd696a45d1875da26a4e300b7ca8c278b4c89dd06e3ed4d347eac4408b2ebf"
    sha256 cellar: :any_skip_relocation, monterey:       "e715578d85f186adf13db75536a27d90bc8e41561a5d3613d2b0d6e71e43829e"
    sha256                               x86_64_linux:   "d7a7c638e47bd9b1e1d48eed4ecf747eb4d2462386029cd3d848aa0130513381"
  end

  depends_on xcode: ["14.0", :build]
  depends_on xcode: "8.0"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "swiftlint"
    bin.install ".build/release/swiftlint"
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: " \
                 "Files should have a single trailing newline (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}/swiftlint version").chomp
  end
end
