class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.46.3",
      revision: "9c81e1a93a367db773f50c85229d942d0bb9aeaf"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86c2506b06992ab37d01194d5dbb2e42d5069ca8b9cb2017dda0506fd4f3c40a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7ed00957250eb23210def831825dbff90efc52087506a46acbf932d3c239680"
    sha256 cellar: :any_skip_relocation, monterey:       "7a8b3400d2a858edf98e7611f581fd5ed2f0c7850635907e234869aef3f5c18e"
    sha256 cellar: :any_skip_relocation, big_sur:        "dedfed91cd2430412ed0654b6af74afcdd2663e016f0c8acaf044c5b5351f6cd"
  end

  depends_on xcode: ["12.5", :build]
  depends_on :macos # Depends on Swift.  May work on Linux once a Swift bottle is available for that OS.
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
