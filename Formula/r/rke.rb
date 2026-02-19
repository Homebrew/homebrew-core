class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.8.10.tar.gz"
  sha256 "e8d7320741644fc785d1c2b02b2876e9b270769f6086d25ee2a4a46c9d911aaf"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad4aed6d16641ce68bfaa9125441e2005924dbfb22dfc2e2702793376571933b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3a920599ab6728a564a5446f96c432ce92adfef3212ea68d66220e9593f7006"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85137172d2c7fb01e230bf05b6eab6758ae46bef9b4466febfa996a0a000f9e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0342ff9cb7582d5748806e956763aa7b4805c1c0ca26d1cd38265daad7fb9a92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84c776d5dc259b780978feb6ecbdece43e977fee6c5d15b8692d1f9b408fed89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "948b1d74396a3021632106480f1c0628951964e77c1ed5d5cf9921ef85c4db67"
  end

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
