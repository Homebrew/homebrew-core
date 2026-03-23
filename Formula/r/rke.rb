class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.8.12.tar.gz"
  sha256 "84e12399e1b140bf35585896aeb89aac9c8370874113728b3b27057126eb629c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a09a69344661ff34198c8bf8fab4df755394b3762a883c207025495f421be70a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28b06b92a6c0050163593f6e48e22d13ecc4b3966805e6d0f6a64ef65dd5d058"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d74a1ab7063bcbbf6fb1e492ad2e1a0ae9a23e60632755939f621c0df48739e"
    sha256 cellar: :any_skip_relocation, sonoma:        "09be09fdb26e83803e03bd73be2191ab178cb65f34005af1197b34e891ed0b45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e19bfd3a8d4695088f17f18817c3028945b4581abb195e1d3d2318fc2df98d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a54e44ff9b7453e76bdc083203840bc12275b2dd1f4645593530e714925599ee"
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
