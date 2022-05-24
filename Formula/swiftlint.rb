class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.47.1",
      revision: "e497f1f5b161af96ba439049d21970c6204d06c6"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13b6b6d881b6cfa3f5399c14150ef6da0f1d1cec2b58fd24c6dcbc432c462106"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "406fb7b019a5b7f0c052a7d4738f6cda5eaf15ef9c1bc1f89bdc3dc2efc719b6"
    sha256 cellar: :any_skip_relocation, monterey:       "3c02d2875bef6dbd474c60a4ce42cce5f9e1da64580c00c351753adeaece5700"
    sha256 cellar: :any_skip_relocation, big_sur:        "775d4db3c21549bb18384be86ee82a43c92af12b74f9135e7b44f448cd6e0eff"
    sha256                               x86_64_linux:   "f00160b4eb1d370d6baf4341341f813af80ba2fcfa2e65657f96153713d1c774"
  end

  depends_on xcode: ["13.0", :build]
  depends_on xcode: "8.0"

  uses_from_macos "swift"

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
