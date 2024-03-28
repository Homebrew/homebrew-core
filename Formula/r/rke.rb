class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.5.7.tar.gz"
  sha256 "a790f65938330b48c997a11d55277b6d6c820f95c5ac9415a87e99d12d43ad3c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1521e5ba89cee9ea7ff5aceee5666b66dacff7c7a358e037e8de5fea9fdd8707"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27198f25e797c8891b9d072f11484ebefaf125b17641810490873381144542e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1c5b06581b64e66ce2856eaa06aa6d9dfb252500e23b3e4b4c3c349f16f4f6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e9724c0502c18fd36f0535d759ff099096f350e920fc91fcc4328113fd5198f"
    sha256 cellar: :any_skip_relocation, ventura:        "7382f9f461f25ccf2dec15dc5f43bdefb76275ba8b5f86d991b639843a78eab3"
    sha256 cellar: :any_skip_relocation, monterey:       "083d57c571daad5a5c89676009c6cdce4a27ac3aa4b0d52646366bd618660f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92ff82b7fadbd27176128c7d2c5d1ad99990cf6c7f2409d644aed2804813ab88"
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
