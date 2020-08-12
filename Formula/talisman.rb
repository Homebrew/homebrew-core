class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman.git",
      tag:      "v1.4.0",
      revision: "b821169359bf96c6923e00732e68ec44e62949c1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "38b29f67639b7cf0a1487df3d0da050a1f386bfb142989f01d9ee751b760f650" => :catalina
    sha256 "84132617d2b54108bb8214e430c86453051c2bca527b48a9c927f4790bedfd1f" => :mojave
    sha256 "1b9cd5dc1388dd311dabf5a910a25ce34ffb0d7d614fa684f8b4bf102f3ee712" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    system "./build"
    bin.install "./talisman_darwin_amd64" => "talisman"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
