class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20200320.tar.xz"
  sha256 "c8262da949043976d092859843d3c0cdffe225ec6f1398ba119858b6c1b3552f"
  license "MIT"
  head "https://git.zx2c4.com/wireguard-go", using: :git

  bottle do
    cellar :any_skip_relocation
    sha256 "783b1eeb0aba2c336e91fe59ef9e8d5d449e51ef3a5ed313f96666c7d055fb02" => :catalina
    sha256 "baf1cc2e7f0795747bcaed6856ce3a4075083356cc557497adf06ceaf28e0514" => :mojave
    sha256 "23d0d338dddebcecc58aa5f1e651fbde03494b0d49071937c4cff0b4d19961c2" => :high_sierra
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
