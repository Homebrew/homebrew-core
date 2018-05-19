class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20180519.tar.xz"
  sha256 "d2b0f43679b3559952cf8d244d537903d03699ed7c8a2c1e7fc37ee424e30439"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "0be24e1d3c45d5b81dbee640cbbff1c9a2fbc8985222efdd1b51dc958b81f6e7" => :high_sierra
    sha256 "b4b281254c748ca5ee189ad0eb982dc60cd1dc482241db4f7ec5794d35f5336f" => :sierra
    sha256 "6d981218bce9a716e97ba76c50b5cc3e85b189d21fea29d6e4d9c33be66654c9" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/wireguard-go").install buildpath.children
    cd "src/wireguard-go" do
      system "dep", "ensure", "-vendor-only"
      (buildpath/"gopath/src").install (buildpath/"src/wireguard-go/vendor").children
      ENV["GOPATH"] = buildpath/"gopath"
      system "make", "PREFIX=#{prefix}", "install"
    end
  end

  test do
    assert_match "be utun", pipe_output("WG_PROCESS_FOREGROUND=1 #{bin}/wireguard-go notrealutun")
  end
end
