class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.4.10.tar.gz"
  sha256 "3b4bd774bc74cf1ea4d1bdb909b6d2ee98a4cedeb5a75a409e1fde310078a6a2"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3d60d62656a678516957fc51d8ccea62e7cb6c7e7aff87cec1417370d5b2fa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68ef38a987f07472d01f6352f762dfc4114ba05144cd5b0676e8a127a361cbff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26edbbf13c60cec7ef68f6df84a5306e940460159225296747eb6728ab781237"
    sha256 cellar: :any_skip_relocation, ventura:        "8ae9989ec941c4f928d910278f6ad10af617c2af5dd16626e62734647d4a84ff"
    sha256 cellar: :any_skip_relocation, monterey:       "faa3a1eb7f6c598c568d5f40cba4f3e6823cb57617e8ff60c045b4ff53e6108f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9e6e22dc26030439b27bcb0dfdab12551035968b690eade7ae217d2ff515c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23879cf39b39a3065e5f906676d540cbae20ba19f6d9de311045d13067deb7be"
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
