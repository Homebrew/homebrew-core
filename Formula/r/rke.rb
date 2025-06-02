class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "788957a4d7728824b0785aed5fbf5ee79c0997af741612bca4152b4907247797"
  license "Apache-2.0"

  # It's necessary to check releases instead of tags here (to avoid upstream
  # tag issues) but we can't use the `GithubLatest` strategy because upstream
  # creates releases for more than one minor version (i.e., the "latest" release
  # isn't the newest version at times).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45e7cd746615dcc044210e07140f47d25275bd4906f986f68d48348a8e749aee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82cc014aa995a580a3f67ce8e4b2b8c8df5a0b128269d85415ce7b2c712016ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb0fdaf6bf164468cf5163343d5bec05424ed75d97d1c4f6d4b6f7f857949599"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8bf4011c6959df445afcec7eb00177e3042604649087af9651873f812a7952b"
    sha256 cellar: :any_skip_relocation, ventura:       "51f6b268683ec88e5ab3249c1d019b49e5923ecf570f8344bbafece7aa829f48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df98acb72efe59338ffa3d8a61c64072c2fb58f20f83afc8645bf8f20f137ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adeef60bb701f2845e6a64ff9b17d51e90168e7b479ab71c85e6681258445c1d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"rke", "config", "-e"
    assert_path_exists testpath/"cluster.yml"
  end
end
