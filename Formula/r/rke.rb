class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.4.8.tar.gz"
  sha256 "8090f3922e419c423ed4cf65b3bd2a873abad5fb6ff55a3f4fa544bbc732611e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45d71247330604fc9751f853bc0056513723ebd6ed63d9a0e7b886e16df2a4ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3df594f33a3088e49eecbae3a96b79c5bcc30c85c92e9200b3b75243130460f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "499e13efccb02e4a9d98650019edc1d599d3ee2e2ad6f9826c605bc74452db3c"
    sha256 cellar: :any_skip_relocation, ventura:        "8898defcf590fff5f0456190f577dae3bee1a87bd484464f446ee0f3441d23e1"
    sha256 cellar: :any_skip_relocation, monterey:       "fa058d2d7df93b2ffede2a4a042afb98858e557debe716eb9791493014a3b474"
    sha256 cellar: :any_skip_relocation, big_sur:        "87397df6de93782b802951e1502493c98ec846570307d7019e4d17611bc6b4a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "040e227225c88c7b9765b5548f31b0ca2318f91a0f7fe457a86eedcd3799a603"
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
