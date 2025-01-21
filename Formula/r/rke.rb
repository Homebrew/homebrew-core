class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "e7d75999c17d49d5232be90980a0fbecc55e7ceddd10f9c997f792c20e71f11c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5ca0af79dfc23a47bef4977e04f300fda6e72cb64b575ec9e69801626438519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94b6993dcfba5e5c0688602d49d90f04275201d5e2665488024dd609fc1051b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "446b92d0480e2fcccb3898a9d789f7c86e42e29ccc05a84bd663919f2a248b27"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc5dadce11fc01b3ac45ed1e1ef983212b802c08c36ebdf3940b87912a49c4a1"
    sha256 cellar: :any_skip_relocation, ventura:       "cc50935ebf12eaeb79d0a43237717bd3d2d2b84e94aedb23c7b4f0e3c80e602a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "937afd4b5c54b43e7c358c003218af4c03e5f648ee52689fbc5ad8702189cadb"
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
