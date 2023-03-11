class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.1.3.tar.gz"
    sha256 "66ff87ce28303f40ef2e8bc4a98e8eb93cd400340c49caac81d792d822936971"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.1.1.tar.gz"
      sha256 "58bd18e21549647e39127346fdc291ebe14053241000f6761841d77465b20f0c"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "274bc18c0087d59f0817ddd551a9110768ac1f9ce1f167fbe62b8cfa124e0f17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cfebad6ae8ef842c1c27e4d1b565038360a14b09c764b6b1b06f31da38d6e18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a64372975ff0b261f2a56fc2572c3086cf5dae0b2cdaec1c1219ee5acf03674f"
    sha256 cellar: :any_skip_relocation, ventura:        "6118eabab5480b0af80582ee530b550e922dc0e73bda493a992b41a7f397c480"
    sha256 cellar: :any_skip_relocation, monterey:       "597cb105d3605ce613ed9d3699365a1dfc3f3c8b459468d17d459c9e84ac60be"
    sha256 cellar: :any_skip_relocation, big_sur:        "90a1855358df8c08ded0d9e17434eccd6b98277cb7d8f4b5e4707d589b154a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "979d2020a52ece6f3de855abfdec8603cbe8a4f76b073604e57f383c572aa260"
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
