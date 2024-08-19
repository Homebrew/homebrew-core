class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "59945974fdfe90484d97322c7cea9d6d5895ddfcd74ea0839077af731fcf6cde"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1aeee3f3645f63459c0d58e1243bf88edad7bb21edf8088e9748dc8b6e1523c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76a1ff46b941c09a3cbc30f8f891a0fb8d13052e4ab947e12d5ba032fcf196ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bf94a3ff5d8afd9174aed6cb87d2ea8287065afbeae1883ff89d2ec69f1fa5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "08aa557410f592a30fc91ef66123fc666820d34e435aca9023c152963064848c"
    sha256 cellar: :any_skip_relocation, ventura:        "1a6bd477f7c91e65789196fe9ba41c0da3d8821fc15ae1cf13774c041aa5af88"
    sha256 cellar: :any_skip_relocation, monterey:       "7e7cffb64bc8b632fa081b239d89b0653a28e7c56ef8b709f3c8addd5af57b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4009a7ea36441b8e0cb062b5a3d2c32c558a61062b166ba60bad015aff0a050"
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
