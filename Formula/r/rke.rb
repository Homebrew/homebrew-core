class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "923a7cbcb4b0a355b66cf08fd89390c96a499a0a35ee3d62340e7ab964b15fc8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e923714fe998d96f9840704a970bd086f989a6e562ac6f434e900699b526454a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfcd54c8f069d6b68c209c7b81cb9de607fd95c668e0fd6305f5a3f086ae4048"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6334635dc623424957aca32e35d037ed40d1411bb5b8b5f4970cb34c5a02808"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f1c40f168c4a4e0790976c3230d748dcc9f09044505273b605300064e3ba837"
    sha256 cellar: :any_skip_relocation, ventura:       "dd7bcb8b7eb4ab22858fe12a2027caffbfa525837ee35c079b5cf438a569be1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5a906789762faf4b067d287a4f00c9bea23f3f7dc287049231033b6bac4ef0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39ed062baea444ca5bb84e5cdb1b96fddc77a1fdc8426a37462eb1931ab991d3"
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
