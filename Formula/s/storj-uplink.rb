class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.100.2.tar.gz"
  sha256 "84cccc9b91098b1c8ae6c3f029ccbe5072d5460c92943d6455c4df7fb75b8869"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy if/when
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94b8761d8f048a0e7556afcf5cb56d41a7b9766e9a2e7325b67a0e8a6c0fc4de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc4fce05f9b6a3c232801912bb2d04be0726c3a7ebc7a6a2fb04de06e7075a31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "278268bcca46a18a7053bef1b856d1b3f34abc8695d37b18651e3511c3a76471"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b32d149a07dd8b8ca92bc8de786aa542f82bb5c14b2968b420ba80fdc1905a5"
    sha256 cellar: :any_skip_relocation, ventura:        "86a6d25a9edf40fb94f32c961bed526e13435664182eb9af77f425368a779d52"
    sha256 cellar: :any_skip_relocation, monterey:       "c703010ae08ceb9190c5d4955a37f6fd89f58da89b340737fcdcef90035470c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed1b8d108a1eca4f005fc0ab66fa5daa1f692dc972c140c684524b87c9fb2bcb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
