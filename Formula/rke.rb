class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.4.3.tar.gz"
  sha256 "2ef716f6492d5f57c7cd05b338ec8bd0a5ba69081ced885d42c39b5cdc387b28"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e025d5e541d7878732bf81ad7ce4c4db8b280dd5a4b044bbbba3c3b867e8868"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afa527cf6487d66e91177ad480fa4c7b25e93c5b550c91c20934352f097ca263"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4f8ef3e818f7b40eccc19e83bb297cb7d8da2f2699f76abdc0d6bbd42f3d725"
    sha256 cellar: :any_skip_relocation, ventura:        "07e9797c09280e84daba14854a979f018dab444345bc2b0a0e6c23d943815e4e"
    sha256 cellar: :any_skip_relocation, monterey:       "2e970ece664cec9344a26ad6ea7bab036004b1a690673fdf1817df96437f1134"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f70a33f026d54305d976a23f0606ffbfc70ec84b23426816a20f5db6866f2e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcd367f20a04e7c9d97921411f42ba5d0abc339e7da94e80bdaefd83c2d2bc98"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
