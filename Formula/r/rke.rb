class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "e6daecf645f3e47c9618bced916e293c56526742f5537ded210ccade4222ffd4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6eb5beae69080c7c40eb6ecefcfff4c4a0786137a5641bfec42bad9edf4e2436"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d036692ac889f44e5d5fcac1a4f75cf45e2108fae6dd03d0824e33fbdbc0c9dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a8840f4325417f1b3b1786fe01d8301208ded19178e22568a439ff3028bfa6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf4613966a537f8744fa881917ec5c5b202caf0a9372a4536c6b6c0270f9441d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8038883c0e973ad364156a73d3a3df55d5a16892bf7bf3df2283cbe9e2150779"
    sha256 cellar: :any_skip_relocation, ventura:       "7726dff43065a138c91a7b8da8b2c802981cdcfc9623c052f4101c18bbcd70fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0584c292c59e51e218a9c1ceea7981915786dc5f51b335e348a8edee3e1f6bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcc345fffcd08f609beb6fbdeee2199c488c87614ba149ff9e2b0718fb4d8d08"
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
