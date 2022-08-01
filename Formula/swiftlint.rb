class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.48.0",
      revision: "22fb9eb9e55b8f5ad9b48fe6f15ea7daabaafae3"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4942fa227daafa9aaf14197f3a5972e4b057dd168e592d236d98f7f337afbc25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e3a73e893d68ed38271e857b81720958bb55cbbb05a3d5bf31b9b67f7eddf52"
    sha256 cellar: :any_skip_relocation, monterey:       "381d414359505bc72348f151751bb77a3c402e9d5ff652579687e3c5391d6872"
    sha256 cellar: :any_skip_relocation, big_sur:        "74d707b9989d622af952db542b786a3ebecc3b8be53762fce8a25ac075f6da1a"
    sha256                               x86_64_linux:   "8aa64a4dce96e961898e41c2240b192a030575571ae9fe0d3a41bb79424fe9b1"
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
