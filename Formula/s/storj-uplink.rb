class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.90.1.tar.gz"
  sha256 "c4b244acb249106d71451cfa8ad53645fe6d32046360a6299503df8c23c10488"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49d060b3d5659db3bc1ef216e5d4c668a795564112c8deacf73c8789528397c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88b7687510e44ee498bdd664e18a132c16672761f5b33468c9d7a7d02eea245e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f85e50214e9bc2fe4562780936b3ccfcbbd854107b597639658c774d8e000269"
    sha256 cellar: :any_skip_relocation, sonoma:         "a08aacd5a60a830b2b1a0957d2a97ce68b9ab6a8a1a3a7416e1c5e9045e31012"
    sha256 cellar: :any_skip_relocation, ventura:        "bbaa7bf075b8f2e9a62fd2cf82c9590ad5b8dd3a61a1b4d6071d22e855d7bc31"
    sha256 cellar: :any_skip_relocation, monterey:       "87287fcec06e00c21d1477b7ff916868de5b0e6de5512b69da3942d26ef6b930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3d3886840aca71be43a87405575cef717fae83a07d105a01d2b02b67daf709e"
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
