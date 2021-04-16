class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20210323.tar.xz"
  sha256 "88e864b28bbf4502bbef71c7a8483921f7888fdb09cff1dbc90e9551e1ab5e24"
  license "MIT"
  head "https://git.zx2c4.com/wireguard-go.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e0a94eddadcf4fb2f62e0dca50c3a882059812c62c142d9f1887bd5d07d1918"
    sha256 cellar: :any_skip_relocation, big_sur:       "131da2ebc99a2ffd47bbb72a785eb9652dabb5b060c359d8bdfac5f4c16cbe89"
    sha256 cellar: :any_skip_relocation, catalina:      "23993db691d81f3b0ff8013f3f8c73d16e28e33a3dd80f3ddd7a297514e5ad6f"
    sha256 cellar: :any_skip_relocation, mojave:        "c3add9aa99b757e456d941a59bd49845bc888de70bc630eb52504682a0498aea"
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
      assert_match "Running this software on Linux is unnecessary", pipe_output(prog)
    end
  end
end
