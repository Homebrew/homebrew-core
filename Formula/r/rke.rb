class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.5.10.tar.gz"
  sha256 "6914e9d15b65f0d97516eba805b576f9a4d285a139704397b992eb2bbcb13501"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed8430fc575f7c73ebda1b13aced84ab048ac881c2029801732cbfaeaea59d83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "537122a19d93ce1585b6eb31c6f6aac3b5da7990f16575270b28b3bf57cb2b48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0533d3a3b20b7e49e695344f82677a916b58ca2d938dfd36dca877fb391934b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "830239452ae3027b5f4fbb40747a2b8f081ea976f2d2f38e92fb4d0c7aa3626e"
    sha256 cellar: :any_skip_relocation, ventura:        "ab08682e421dc87489a2a948afc7fb3beb0af7d2cb9da95709388fc7651cbf3b"
    sha256 cellar: :any_skip_relocation, monterey:       "024d094ab9412ec1d2b736c5e65df7d01a325df08d5ea59a70314cefced08e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a82ab71341c3bb475e6771642ca364637393d7ea3fbc90ef559eade1c6100ab5"
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
