class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.8.8.tar.gz"
  sha256 "77f1f5533c2cf1cd4b51da59b8bbae4e95352c036dfadd0a79b6f33e0be48a3e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f1f641e6b05ec34f534c4935fa3304964b7871285ff0b1fdda21182775bd362"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "003438f6e667eec6ddb5393fbe17e30d9427ef8b88afcf6ba717cc69390d1c2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc9ba16c19f28bcf784cba0247e2ee673fc56bc9129799e35553cf4b15a52c61"
    sha256 cellar: :any_skip_relocation, sonoma:        "69fed3bb06965645bdc13e5806cc872229f634916513d761e49371f5fe441d65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3759ef887c34616b7e5de4eaae940b4f345837461ce3c4e1c74b4ef304edcf30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfa53216d5950e9fafee13e6d02de65e8532019ef48abdb67eae8cd337da2e65"
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
