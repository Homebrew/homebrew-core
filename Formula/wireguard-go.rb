class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20201118.tar.xz"
  sha256 "8b9f3dd5f7083118fae9259868f994562270167a7ee9db28c53f415f0b20a388"
  license "MIT"
  head "https://git.zx2c4.com/wireguard-go.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "efb79650301180cef69d3d3f300436c2f8a799318ab176ecf1e6ae32bd55f45f" => :big_sur
    sha256 "bc158ab30671d54381f9d77200468c211df5c95d3977a28b6fbd2bfc9ad3651f" => :arm64_big_sur
    sha256 "14d8dc66f51aa9fe8e8a727b0753a73f454ce35de86436cc880e9e9d8c768d87" => :catalina
    sha256 "dc5491d1e72ced9c3f43e5cb36f639292641848b85ce70c88d9771079401a0bc" => :mojave
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
