class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "491e354393fb5c2dd84099c12870c056fa55c209f8c89b2285a59fd123b0f7bf"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6a52e12ac5861712ff355b67710e4a1f1e147d6834f6207172c97374b48f15d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bc35b5ec0a42cac3aa81d889b1aabc2bfeccb032bf8c37ab5339c2e4daa7f65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19ba1a0e75394f43a3b68106aa71973baaf085ecc0fa26040bb534e3fff585d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d073b846dd8997650333c668a6fac585908ed64f1b12397fd503346486630499"
    sha256 cellar: :any_skip_relocation, ventura:       "b242e8c79156f7e2fbba7cdc10d3deb108e1e5e10bd874f1b603f9b4a72ad1a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "046fc7520cce67e6d9a5323321450481ec07689c46c8c4af163d8b599d807b9b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
