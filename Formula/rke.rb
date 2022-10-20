class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.15.tar.gz"
  sha256 "1a508964661142046d93fa7a8b49031fc5a0c541d29a726ca87ab13d4e043c96"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc006e3ca62c06bca1b0b91bb1c7328f1733545a0c3e1c5ce444e40d5424ad36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04185a1567a408204b9105522859ab2fecf976e9fc6607fe659dcca9634e7e14"
    sha256 cellar: :any_skip_relocation, monterey:       "e1bebdc27a66baf60f5143d82735a94e69d463bb3cb13055099658cc7d593524"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0fe766bc6fdcb9cfe8f61d95d9d80617ec8344462a37ffadc6a88ddf5c27bec"
    sha256 cellar: :any_skip_relocation, catalina:       "b9e257b24818ef8cb4059ed17f0b2d60f0618158af3b77d94847309955509355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4248f3a2fe35ca767f80f5dd09d16aba4ca0b91eb6163e110086158f0c094a64"
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
