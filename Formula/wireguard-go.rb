class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20230223.tar.xz"
  sha256 "ed3694e808d96720e79e17ae396f89f7c2024da07f3449ff0af8fbc6dbfa7f6a"
  license "MIT"
  head "https://git.zx2c4.com/wireguard-go.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3acf6bab85bca095db52bbdcb62f13c9e74eb8422c2a1de6ef2783ebb568e43b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "122189d1822022e73e9e525ea8a471560098a72953b1c166183e8b0db7036d65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc63a4b505ceb31f676e38780235436e85f88b1c5da9c918c0e73f1d13e2e0ff"
    sha256 cellar: :any_skip_relocation, ventura:        "3416e1bada02bd49344bee1791a9219e946f26e54616c481d72c345cb464b785"
    sha256 cellar: :any_skip_relocation, monterey:       "acb4c151fecd4b2133f43af3e3ce130010a2acd511e1dd67ea544f8e67f9e565"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae4ff4de0f51cba3ed348e1a6125bb0a4014c6ed593b27ec4d35878aa56ff49d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cea569e3ebb40ce3e341edacbb5b1c451c05534c2bdacc0d73aa2f0da73b2725"
  end

  depends_on "go" => :build

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    prog = "#{bin}/wireguard-go -f notrealutun 2>&1"
    if OS.mac?
      assert_match "be utun", pipe_output(prog)
    else

      assert_match "Running wireguard-go is not required because this", pipe_output(prog)
    end
  end
end
