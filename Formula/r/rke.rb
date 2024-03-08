class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "ddcc444fdd8f7eb5a094c183085c59af80c20d01ea3a51b6b517c07789f9c007"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cbd4499d7419ec717cdc4e00f8071f45b32e5f00db6662b4e603200afbde609"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbc9db7bfc28d66103e99e147f52572fc7435beaa28f00d4eda2b36d997a92e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a806c1130ee621430ab4a8192f0e95bfadb8ddf60d6cbd24a16fcda8005aa6bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "be150c9a296614c154f397a87657983dcb69a56dc7a8f36e032112da738e3df7"
    sha256 cellar: :any_skip_relocation, ventura:        "ef7ca40e5b27b95df7f4ab9f740accf01f9f598518b3241c888eee6c8ac8cfee"
    sha256 cellar: :any_skip_relocation, monterey:       "c5cc383b4e51f456bd9c3450bc169667fd23ee33c54ef59e12f58a024cff8bbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7118f896d7c076ff3dd864e583df14f5ab0fc850953d5023805bcf74f2a0a009"
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
