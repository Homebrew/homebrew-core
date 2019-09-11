class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20190805.tar.xz"
  sha256 "2f56d2c4ebc3e50d581e92c046ebf3c884c703c4d5b3b484e45f55e50c0034da"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "fc2a6f0a2fe597d4ea294c939bed54cc0d06b2fdbb42cac9ea5016027a536417" => :mojave
    sha256 "9d396bc706919f476f85140f50bb05c092b9d49bf9a9fdac5c5936a65e956a60" => :high_sierra
    sha256 "579a9a2ac5a5c9c522aaf0ae76d8c4729e0bea99bdeed6e7b6eef787fb1b1881" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "be utun", pipe_output("WG_PROCESS_FOREGROUND=1 #{bin}/wireguard-go notrealutun")
  end
end
