class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.157.6.tar.gz"
  sha256 "2d943654e194fb6633ae0d63ba09000f557f5c6ccfb2858f9b3d64abbfa76ed4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "993095f15f76c8ece86927bc2ecc37aee1b717c903b1d7e92bb7a578898b9038"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "993095f15f76c8ece86927bc2ecc37aee1b717c903b1d7e92bb7a578898b9038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "993095f15f76c8ece86927bc2ecc37aee1b717c903b1d7e92bb7a578898b9038"
    sha256 cellar: :any_skip_relocation, sonoma:        "58f3ce3fb8b745190411e705beefe20a7c112fc13083c9551e6fd219573607ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eec7fed1485e8dd7bd64af308bf962c53e4165a1812b6296852bc36f21fd49c9"
    sha256 cellar: :any,                 x86_64_linux:  "6762d2edb1a5fbb416c6a24dac63f81b6562164a9bc34cf08f626451d7b6df77"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
