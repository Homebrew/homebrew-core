class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.4.2.tar.gz"
  sha256 "a58ee423d7229faab02452d7cb815a83dd2c91de33c6202fa024e86a9223f716"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2723cb5b0edf8b46871d376d9455735684faa1e0944cc8f942581b01d869664"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2be111089df4dd1f5e9f7c99897fb286afa416bd0a671c484b9a570fac714f27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0df360ecfb9412532dbd21eed753aefacf8a22bc2eee09872e655a7570039cf"
    sha256 cellar: :any_skip_relocation, ventura:        "6859ca6caff8d87f4bee2b45633afe5b33404d998c48320d04e886a2383f5a34"
    sha256 cellar: :any_skip_relocation, monterey:       "f2c788eb6b57b96d5af6030b349a1f93ad500f31d4e25b52cb76c857a545989d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f34baa4ab10d4f15d1ed3bc9fb5f4d3069d0d57f1e991b63013aeb7a71ebb3b1"
    sha256 cellar: :any_skip_relocation, catalina:       "44a1f79133a865bf15fc040cfd95d9afe6734f50344597213ac7a303d8895e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54d5d9baa05ce3a14ae792e84c62e482d5580fca63b752f89182ac82723bc39a"
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
