class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.6.tar.gz"
  sha256 "74590d52a9eefd12a473cd91515187ca9919918c0cd2c2b6b7260c7faa53ba86"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9fb0dc049b6a884ff239ba78aabdb0114add06a758f60cc3e9210687f1835b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "117369dd270a042c780413229042af4834c8ec08d844d712a1c36f528b948b71"
    sha256 cellar: :any_skip_relocation, monterey:       "a04bbc584595b1179980c6ba567a5ecfd6decf439f2e048d31f7d68a19777b63"
    sha256 cellar: :any_skip_relocation, big_sur:        "497a13a50525758b4e6cc4632b8c0dcba9cd1edaba1174796d7179c639ea3ebb"
    sha256 cellar: :any_skip_relocation, catalina:       "7640bc344b3202579944425d786cfb2b2d84f3448fb68637cd333e321c83e99c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3b9b9c17e7cdd84426c112cf4894878cf76deefe1ca2dec2cd191a6cc93221b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
            "-w -X main.VERSION=v#{version}",
            "-o", bin/"rke"
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
