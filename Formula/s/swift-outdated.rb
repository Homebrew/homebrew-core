class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.6.0.tar.gz"
  sha256 "25491869d5d1537bb4923e33ac7e9049a9b3683d7936b3c7969eef5d12b509a0"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c05cd286b9a9b32b3f1bfa82c543f2be46b965d967a554835cf49d2176181253"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e3a3229ddb0984afae4a2fe8047b8458cdd556c669e46638777b411bfba896d"
    sha256 cellar: :any_skip_relocation, ventura:        "a349f57c27fa0e81b2e46f4694b95f6a990a05ca1f76468aca23f523b56886e5"
    sha256 cellar: :any_skip_relocation, monterey:       "5d546e5adf358d4cc78cb50bdf96e27a675d76b671b22cd7120a80af72a2816d"
    sha256                               x86_64_linux:   "a5f35e36caff72ca3c1620f058352f1e15241b7120bb6f1999df1615ecc39f6f"
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
