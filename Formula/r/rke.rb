class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.8.7.tar.gz"
  sha256 "924660338c75467112f954db672eb9db428ca119c830179e2c2943d7601366d8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21db2391a28c8e7f8467418de57a3f0ffc233902ccd8bcbafc7f22077f79870d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4e839f1a8048ab5e73313544c56280ab3db9bfeed84a21f27438c2fec9b3fc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b89007437df059a5f27b7c9eac142b0a0a667f47c160b8e6e50a7db85b0ca59"
    sha256 cellar: :any_skip_relocation, sonoma:        "e656b5820654440d03b1141a0be42b37de5f4f5085ab24afd9d72a02f2afb596"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f17c425b64af9f06b6a0c18d2d5ddbab2d680e90fd2c9a6ae45aa92c14dde40a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d882b291d73020d84903af74e23ae56fdef5399d787e17dc978b85bb00d01099"
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
