class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.4.4.tar.gz"
  sha256 "25c4a19595af1471469b1bc7610125ea40808b4df78770d9f008a969b5731937"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d9e34b63697e29b656f79f3e0776f3fdd7cb2cd232844714fc57d43cc9611cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cde674516ce5cf2253b8a15486d738bc9d2b7c908e11443eb2c3714f4aaa282a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86a0b9a3c8b5b09aa5415b0dd57d3ce445fbc7211bc6a6caf803dc77ac01b5ee"
    sha256 cellar: :any_skip_relocation, ventura:        "ecb07ac95b103f8de1be15e8155ad77fc478654973f31c2feeecbdda31e71a7e"
    sha256 cellar: :any_skip_relocation, monterey:       "443f27e3b9e1ea62ec69d8ed0bd13576158744b0e80b5b2e2cfb91296ca6291c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8ce30a363ffa45d554d8c02f99a6217ba2cff8011b4d0b2b812afde5d0c7465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8cce7c2a5b16068292b632b10dab5c88a04fb508883e20bd8c4db9318c4051c"
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
