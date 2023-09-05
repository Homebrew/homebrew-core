class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.20.0.tar.gz"
    sha256 "a869d139a3b47b7ec38f3b72a6ae81be5278d19dbed5e65727d1c183d2e4c9fa"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.20.0.tar.gz"
      sha256 "c4a3b143f1d1c45679257fd7805c2f708bb746e3ec8486eef68e73d19bd21676"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b52eadd31941796458bdb01e25afe9f959841cc3864cf5bc533428be29ff736"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecc6ac0829e781d0c96b5d1e2db4767e7cc8bac28fd94d123238873bdefc327b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93060a95e5cd5c5c345fa30ab207bc97009e4c36ddd84c6d80f284cea1ddfe9f"
    sha256 cellar: :any_skip_relocation, ventura:        "4df784b34af5b64b1f6f43dcafce6bfb264b570a30da4b5de8db3fad4aa83eb1"
    sha256 cellar: :any_skip_relocation, monterey:       "dbd5da75f2e165cfb42957ae83be18ffb519ada38720de67be3b635f29c0a356"
    sha256 cellar: :any_skip_relocation, big_sur:        "376e88eaa065d4ad58202ce70ddad46eb00c7952abe71e75911cd5de04048513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c183a8c88195a281b05a509a23884c15361a3fe0499f9bb2e939363c964c1714"
  end

  head do
    url "https://github.com/ServiceWeaver/weaver.git", branch: "main"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke.git", branch: "main"
    end
  end

  depends_on "go" => :build

  conflicts_with "weaver", because: "both install a `weaver` binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"weaver"), "./cmd/weaver"
    resource("weaver-gke").stage do
      ["weaver-gke", "weaver-gke-local"].each do |f|
        system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/f), "./cmd/#{f}"
      end
    end
  end

  test do
    output = shell_output("#{bin}/weaver single status")
    assert_match "DEPLOYMENTS", output

    gke_output = shell_output("#{bin}/weaver gke status 2>&1", 1)
    assert_match "gcloud not installed", gke_output

    gke_local_output = shell_output("#{bin}/weaver gke-local status 2>&1", 1)
    assert_match "connect: connection refused", gke_local_output
  end
end
