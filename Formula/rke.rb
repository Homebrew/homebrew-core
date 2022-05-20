class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.11.tar.gz"
  sha256 "1522e4964f0c68a00cc1632c5e7608802d37e0508d29517ce8401d3a848ca14a"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cf28a3024f9e154485680c9ccf745f181aa4e429131c65de2962db030e89f84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee5671b5a1ebb6df176af87370c8fed106fb963d27416ac053b809e6f9a06c21"
    sha256 cellar: :any_skip_relocation, monterey:       "a01cb2f6a9816309b1a40d3aabb8e9b580840bc2629e6ab6b8b95c0fa977d761"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc22ce9d7aa3b10e42de87f28becd5a93ea802b3ef95aeabc2fe16cc7ac6266a"
    sha256 cellar: :any_skip_relocation, catalina:       "5b7b64c59645590071165b2a597bc167d4e764b68565baf9c27c7aac619fcded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "692a1ed2605e69f87130864ab75bb69d79719e20280c6bf5652896f02294677e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
            "-w -X main.VERSION=v#{version}",
            "-o", bin/"rke"
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
