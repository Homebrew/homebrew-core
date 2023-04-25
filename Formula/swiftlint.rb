class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.51.0",
      revision: "eb85125a5f293de3d3248af259980c98bc2b1faa"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "512ecb595769f901cf75b32313b17a4e670940245ff24f755ff1a3977a15da83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4341feca59da7d9918517c9017487bd810d4a32d3ea3125323c65f65945c9402"
    sha256 cellar: :any_skip_relocation, ventura:        "2b2ce72f4e9b9f6a9f8014415d7a2662024cf3747f2e0a593375c2b3095e7033"
    sha256 cellar: :any_skip_relocation, monterey:       "06926e0e327742f4dbbd7528b1a5a847a57227062780ec7502bb0d7e1ad3f9d8"
    sha256                               x86_64_linux:   "ef46916b9f189ce18045273a0a0f2d155a1bb3bea1ac5e1c866f6df080d9dfbf"
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
