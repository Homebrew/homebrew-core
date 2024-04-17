class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.5.8.tar.gz"
  sha256 "b5ceb9325e4b00c1cb029a638517e3ad3e65320d2fa1edf280314f8f059d3e4d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63d6a074b8efdb069f276a324859da9ecac55a5e3c2367d2ba900e7555a1c949"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3b5379f8a6c0eff107c713defb79b783405a3b4c37d521e780eae7eb8c4d1b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e3e7cb6fd26c348a8c34b7db9e276b97c37f1f2d3660f7fe5ae03b5b2a71a5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff746f870809e02b9199dda2788bdd0e49a7990cc3c7dab5b279399cc947c1e0"
    sha256 cellar: :any_skip_relocation, ventura:        "b83747868c9a9ffe372685309a8c01a6ee77e5c87060365cac5d0425f31a21cf"
    sha256 cellar: :any_skip_relocation, monterey:       "bb5b8ebb71877b8edd677d8d53c4fe21ddef4464f56236ca80d46dbcb92222d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2b15cccf5d53064902116227837455188173a435ac42ffba7b654211f44d837"
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
