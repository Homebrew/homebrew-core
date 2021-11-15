class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20211016.tar.xz"
  sha256 "25c9ec596adc714fa456f88b61704bb069f17be3604d1c9cfae96579c924361d"
  license "MIT"
  head "https://git.zx2c4.com/wireguard-go.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "615e120fd7feb068f5b9a0e1a67e33ebf402a2b860e33e7cdcdf57a00bf9f0ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd13831d9e412f6d017dbea6e97b38fc969bd5291ff9c05c5c8f112a37542fc2"
    sha256 cellar: :any_skip_relocation, monterey:       "7e152bb6e2cdc60a5288d40c3baaee7535d784fe6cb47390cb294c126ceb65ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "18fcc7e4677df06930a4ccad74386322b6067131f13a493478954da38a4e893c"
    sha256 cellar: :any_skip_relocation, catalina:       "3a223d5f51f2cd4767526c5f7642d076b01b78468981b6fd996a36104ffc114b"
    sha256 cellar: :any_skip_relocation, mojave:         "7d5b923175d036e008358de3f15cce66c5317d742cbe22df52bd6bad0f931f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e7c52f5160ff952fc0e27b844ee783eec16ac7d196cb96a29f6900b49421c4d"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    prog = "#{bin}/wireguard-go -f notrealutun 2>&1"
    on_macos do
      assert_match "be utun", pipe_output(prog)
    end

    on_linux do
      assert_match "Running wireguard-go is not required because this", pipe_output(prog)
    end
  end
end
