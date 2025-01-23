class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "8a198312152ed03ddab24f47c25b301bcb47ae60009c3daa2774532ebefba29c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5d8f406b8fa4efff71f9a6c0073bad447a47fa820727fb48fad401f5e81f309"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26c5ae690f831d963fe19daf8a72fae87001b7d003a93d48be70506bcd3645ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef4877cb0f88bac66a4b6a86bc2798ad59ea119b12df300601bf979e989afd96"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc531c0047be0e69bc7625f426899035989178e6486790ad390aac2f252de3e2"
    sha256 cellar: :any_skip_relocation, ventura:       "d2e8a43335b8fb69f60490ecb02a7b6db0266be2a3a4087979c75a03ef09454c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c659a8aae938e5430626f5c63e65aaa01ec2ff835a0bc89dfda2bb648512725b"
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
