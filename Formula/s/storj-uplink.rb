class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.114.6.tar.gz"
  sha256 "faea05c931a251719a762cabf62383761a06e79f6f51f3cd3ea550dc73d5d772"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f7d138dd734b175a28d0367d64da8d075c734fb7e7ddb1e8535e35b838cfe2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f7d138dd734b175a28d0367d64da8d075c734fb7e7ddb1e8535e35b838cfe2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f7d138dd734b175a28d0367d64da8d075c734fb7e7ddb1e8535e35b838cfe2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "84dc7e9fd2fd04cc02c850fb9a114456969690cc2b4aa34a2bfced1d871b1b0c"
    sha256 cellar: :any_skip_relocation, ventura:       "84dc7e9fd2fd04cc02c850fb9a114456969690cc2b4aa34a2bfced1d871b1b0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46cfbe225bf413753373d2fabc2a82a09a1ae6bdf728b54336fc1201f033ba27"
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
