class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.12.tar.gz"
  sha256 "23e1c832b12063bd5faa04d166d3560bc036f7fe05fb81a461fd80055b863cba"
  license "Apache-2.0"

  # It's necessary to check releases instead of tags here (to avoid upstream
  # tag issues) but we can't use the `GithubLatest` strategy because upstream
  # creates releases for more than one minor version (i.e., the "latest" release
  # isn't the newest version at times). We normally avoid checking the releases
  # page because pagination can cause problems but this is our only choice.
  livecheck do
    url "https://github.com/rancher/rke/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7588ae359156ec3894a1c72cf977dbc8dd762e820a7a02672256a74d0af099f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36a2b8d1f50d2d8b32aa3259d5dd67b2bffe33007a638d115d0f32ebc81d047d"
    sha256 cellar: :any_skip_relocation, monterey:       "f4f61836a5f32259bb72d239eb0e0cf67d78236d6ac8118749f70731bf6f9222"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a92e9d019f3fddb1449d955135a4e27dc94397266f1188e4fa9b1abcfd97856"
    sha256 cellar: :any_skip_relocation, catalina:       "dda914969ab14e0e1921554fcbb7fa6d414e03a52c5aaecacdbd53cfad500a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4418ae8b9561f79ddc4fd14e6c707553ac2242e336af300bb9c658c5112f8cb4"
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
