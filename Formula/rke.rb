class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.14.tar.gz"
  sha256 "df7ea657613a80aa5e97904a2d3b5c5660c2dfa60658ce37889cf9d71efbdbe6"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbc42fbe6764b17877eac4e329cc4c8263c2cf76c17d6c85e54056d6906554e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3994041223c8800e85f696633fe6fb8b4caecc66f230c921e8cb6ccd8e6c7a1f"
    sha256 cellar: :any_skip_relocation, monterey:       "4711aa3f4e42a17ae7965e28adc234ad6ee2f4790d98a6c01b6f283cc773cec3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8212d63763289afc9c498448329c376385d0a5c9b88e5ef54548f746a93208c4"
    sha256 cellar: :any_skip_relocation, catalina:       "d3e73238dce86f9b4283e34082c9736e88839e7275d6a2f9adabc30648e617c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b38561fb61297e88d8c624a4d5f390dd1e4f96bca7d466e888824c88c0879ae9"
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
