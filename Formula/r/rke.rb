class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "9f1aec9b0ea7a01bd61400e5e7aff414dec5de87fdfa9186998031424a35f483"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95fdabe16df78c408fc90ee47206370fbf71f4f23df05738b48128c00147100e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "873385d543ae7dbe9e30e7505edd56606e1886d7eb18d718c7e65cd459b66040"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9af61b72546e790543c85a3d37de5693d298e87dbcf645eaad3f4b0709b01d43"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ad0a93feea93ed733c4d93bcdd7597ab9c84da1efb894cdb45b08b90d443a0a"
    sha256 cellar: :any_skip_relocation, ventura:        "ae9ff3017fc3ed199ed8345d162881ab399f4edefbdfe56a4528c539415919e7"
    sha256 cellar: :any_skip_relocation, monterey:       "521165b13562c21ecf3f462f3014c43e0a1bb2ae95a470db80171f283e9224df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06c78fad631c9a0adbd3544e4c76f18524aa71d9227e689e185809b3f7ecc87e"
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
