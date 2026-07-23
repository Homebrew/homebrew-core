class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.8.14.tar.gz"
  sha256 "94c7930564f52804513c2ea09430bb7ada0ec44bde73493d5bce35bb19db4881"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e1d37ff45d3fcfdaa6d689f00dd2ea1ec0b582421554e49fbe9330ea3f54f51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0a47f83f745fa6fb941d1e4d158abc5cecbd94eda5877bf31062719c52f3327"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57df4a20f5bffff930d80f52a3493df741111667e53e95ba9ea9c19bd08b3662"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9b0f5d6f64b8af447d75e01daaaf9c31ccec5921405af6f219150b76784b941"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf9eeed2b407307206c224b526b0849a44b0d0fe53026e610e727c1a625abc49"
    sha256 cellar: :any,                 x86_64_linux:  "07fe86aecc48fb728a7211c139c8233ec8fc3d4ad9da692fd2f098629e74f6ac"
  end

  deprecate! date: "2026-07-31", because: :deprecated_upstream
  disable! date: "2027-07-31", because: :deprecated_upstream

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
