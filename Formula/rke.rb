class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.14.tar.gz"
  sha256 "df7ea657613a80aa5e97904a2d3b5c5660c2dfa60658ce37889cf9d71efbdbe6"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4ed2b86d87ff2c8ef7a244febca29f8f38e0f7af61e332ce73509423eab2be5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e09e7260fec9756e1951b61f1f908c4026a3cd32b7c5c9574bf0e6c12eef08e5"
    sha256 cellar: :any_skip_relocation, monterey:       "90a7bbfa182a52c80339c52627602dfe4ede16cb0ef135e0dc7545de699098c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "846503c17d514324fd0f0effbdf432edef24bce3c8fee235d0818742aadb66da"
    sha256 cellar: :any_skip_relocation, catalina:       "329e835f85f33383533e275de2e62648abdf01e71f629276b33fdb894e2c28e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e7509f97abe35584f5aa641f63823a168d38271c05a46c4a7f7ddd1ed4aa7fe"
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
