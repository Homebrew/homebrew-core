class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "6feaad32807cae5f86ebf32fd325664c9a17ede09e48e62ebe63b8e9e8fb3ca9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ff781281534d8eaac33a99382894422571a3f98b0998ac3c2beec7ba2e67775"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b8a55075d235aa87cdf86d88808a01ca8128ef4f1b26d301bc1a13956f107d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1d6f2acbe5f2d40e82f5106ae8507fcf2821910e4af6c5beb717c389903759a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f54610947c3ae59b05c5e9ea46c8924ab5e2b782c73f0cef8c28d6c48a4b6df5"
    sha256 cellar: :any_skip_relocation, ventura:       "0f5dbd11a4fb5e0f6005d77320860e399aa21d84e375e25c9351805793eff9e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bac73cb84abfc19f10fd2c380bf02560a3096b465e68215e1a318bb3537e8c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0df9c171dfc585fec655c380e02c77cc447a09dc7c08ffc1286d66b5912c7b73"
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
