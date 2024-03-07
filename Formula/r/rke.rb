class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "8f8949594a6455114a12c0a2cd1073bafe540a7e812000d64a532908f61943fc"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd44591abf4088458dd6b511a21123bed1bc7975768fd75ef7b3a42f14b33d6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67a0c5d4c4fa5ca6e9997f23e1cf3b325a5e31019a0dac188a0acb9970858fa1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29f9cb241f50496a6f5a98cdd860db2a5370df0eb307f03af181ee6b1b5304cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "95398485c322043368a7aa1a51726791ea8c2b930bb3798c8482b55f155f7706"
    sha256 cellar: :any_skip_relocation, ventura:        "652e59488f21cbf2e941fa01a4a9092378f99979de06f7d3c1eb5c823eaf3419"
    sha256 cellar: :any_skip_relocation, monterey:       "50a6a2ad47568ef41b092b56322ae3b95c199eeecc940f3d712b35175c869908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e415a56182cc94d9fa90e0fd09d83a8adc140f00ffca71fdd4bbe184d12f35c"
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
