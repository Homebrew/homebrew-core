class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.4.0.tar.gz"
  sha256 "f16b8875eb3e423e15c03037562bc6af56adee7b152556ca247c5c88a34d35ad"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afce6d478f71fb8151512e9bba92f69674f88470b835f2c34b7d3bf4c2bf3585"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6acdf440c631091d0b944be2ce7002a8d4d4bf70cfd69f860bf3ecc81977a42a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8201fb7c967925064faaf6d77d9a7320338dca798ef7b118ae9d98ff9345318a"
    sha256 cellar: :any_skip_relocation, ventura:        "f41a037c4c86f247c9ae534100dd0f06c1755daf03bfbd5e4aa9e4af4011e5c9"
    sha256 cellar: :any_skip_relocation, monterey:       "44fae476521cebecdffe01809c0da8f878407da80d2991a5096fbbc2fa494da3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d04e526ce9f2f59c225e22e192bcbc8af740a1befba8e68aabd3f88efd5f5b08"
    sha256 cellar: :any_skip_relocation, catalina:       "9f7258f95347eaf00c91d303f6ff7b5ad165459b4137bc42a589fff9022ad7a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d526f5b53e1c1dd2d9b2b69454c740a73754d40cf97032199ffa2fb66bad47dd"
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
