class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.8.13.tar.gz"
  sha256 "1d4af9e45225eaba1d9038a133f86fcd529574ca971c65096b6c4dc2f220a6a6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cc08970c661fe33ee24b7bfc73f53503414cc881bd90d90570b6bccfa9d44a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aff2f601decd40399318b51a4030d2883c54e10c43705fd25029addd397841a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9103072a01bd3d80c0c4310409240f96623218e87484253d7a3410e1d885bbec"
    sha256 cellar: :any_skip_relocation, sonoma:        "71dd0ee4591072fb19ffef92748cae476d220f2588ca7eaf8e473083514102b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28c7eeb5d7137c9069842160521badd8eded593125a2c8d7d5634d9fa67addce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d77f54bbdcff8784b5bb0ef58e4dedd0d78962359620935905279704b4373ac8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"rke", "config", "-e"
    assert_path_exists testpath/"cluster.yml"
  end
end
