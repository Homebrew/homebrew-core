class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.4.6.tar.gz"
  sha256 "12310ad4f9f8757221acff842cf9477d21b1f6f8b83fe0bd8a3409982349813e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b9c453bcecabfb447662d5548e0df3ef7a504ab5a9932ea0ed3351946954327"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc90436a65b92f40f3a14239999e4d2ec4c858b70c758a4bf00dd85c609cf636"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93c7cb7a78767a264dd57332e00bd7cc502d147ec66fa91da92c1a8e315c9cf4"
    sha256 cellar: :any_skip_relocation, ventura:        "670bd73728cc32fe1effd8912b15658de5e14b1b95c05059aeddf448ec9912fb"
    sha256 cellar: :any_skip_relocation, monterey:       "d4a13ab8d79b59cd61c52f9d557907f0e9e49d3b40ac4c54b4399239bc777443"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee2db9b715a44ee87662f3cededf0d0815bc141f37c38500b75511975d68ab52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "302d37637467b2f49cc75c48e87764e0a37e48ffe72e8376f92302ed67dac1fc"
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
