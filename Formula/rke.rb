class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.4.5.tar.gz"
  sha256 "59b83c087ba3d5648afcc54060dceb6e18cbbf06f8fbed9e4e8c378b2eded4cc"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf48c5c430aa6caf05fee1ed54ab89b59f3df9d5e4b776257079019a951c4a76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d621b81aa6005f6a6560adfbd01a8cdd65121ce6c452e59c1b7db25782a8c14a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a5b599a201de9512a99e4c80ad523e29dc371d256e4805f9a00dc2e47b8e23a"
    sha256 cellar: :any_skip_relocation, ventura:        "753575e7b5b5aa187a131df0a95228b1814f6080b4e7b06080feb62e789f3fe1"
    sha256 cellar: :any_skip_relocation, monterey:       "68747275a3136622f7644014016124c63f06e72e4a59a52b6134a0b2cf911dea"
    sha256 cellar: :any_skip_relocation, big_sur:        "17051701c5fb1136b6b5d9b719d8db1068a3a8c2820e1bbcaa0236509c982d71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a2e4f80c38297a5cab7f6558e5b6fe538d5bb2fd7c797c977e60417948cb920"
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
