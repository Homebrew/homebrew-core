class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.8.9.tar.gz"
  sha256 "5ffaea0ac94ed30caadbf38fe6aa6937dbdb45e26a00c0e20809683757a8c03e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b617210c51bee96618e24eaa53d4194a3226a2fc804c6870c94f17d82dda9551"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97abcd2082512bfcc806a6fb868ac5e0e03c9b3c6dfd54ecc93a0e72978a3f05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "525f005f3f545d0da8c853ca0148d4c07741679b453dc45ddeb842a8d674872a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef0da6e507e097c92f47f30e4f1b499a18ea05d884d2f47b99bef4470e74589f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1828350daed91b267c2ff7fc198a14c471c4a94be3463536f2507f21454fc48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43260a4185868b68ea7dec57e2b6e4cc96b55e26085b5b7cd77b9ecaf1a1b5af"
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
