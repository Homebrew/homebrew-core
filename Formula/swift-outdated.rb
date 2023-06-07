class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.5.0.tar.gz"
  sha256 "7226e38ea953a3242cd36725faad9e09fabcedd8dfc78d288b666cb4ed21d642"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af57d21e4aa992cc8c3cb27576c395bbbc7cb5cff99dcb3e9fa67d3f1b84ce5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fa007f408e2c4da1b5b9c89adef8f624db8d1b94a2260e0660959c41ee6e86b"
    sha256 cellar: :any_skip_relocation, ventura:        "59d45d4c83c96c2c0bd316e81a522090374588a0d3aed660099f2ca85c3315f4"
    sha256 cellar: :any_skip_relocation, monterey:       "307f5e08746e235b57c076ebb4b0d08e889f423daff686469daafcac718b8c81"
    sha256                               x86_64_linux:   "afa3a1f722f13169d8760edbf9403785229a2da1ab345cfaf63b39e81e1b1d78"
  end

  depends_on xcode: ["13", :build]
  depends_on macos: :monterey

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/swift-outdated"
  end

  test do
    assert_match "No Package.resolved found", shell_output("#{bin}/swift-outdated 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/swift-outdated --version")
  end
end
