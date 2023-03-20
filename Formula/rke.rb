class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.4.3.tar.gz"
  sha256 "2ef716f6492d5f57c7cd05b338ec8bd0a5ba69081ced885d42c39b5cdc387b28"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95259a5b041bb814efd5a88617948c4e23b0790f0c9b14bfe5c09f44a4e51cac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2b86d0d509773356f7764f14e3c1211c9c74a0df0ca08c26cc801c14942efe7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26a6611b3a067d7947d5160b9dd29bfb7fcae8b775f6c6f8f0271ab3eb748f7a"
    sha256 cellar: :any_skip_relocation, ventura:        "35f27cdfa4bfb5dcd150c1f51c12c0e4da3cdb7638db1363a84dcd5a49ff19a8"
    sha256 cellar: :any_skip_relocation, monterey:       "abc826db6c093091d73cbb2d5ddb704de61efd18c6d43332e7ec6c5cca2dd0f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bc51a8776e3397273f9aef30c2f236bbcdbbf42fc06e563e2761034f21b88ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37d4fd1a7f72fc2d9d22e77eb4e7b5eeefa988f72d9f0040b691f54cf6a39ab2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
