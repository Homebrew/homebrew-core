class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.166.0.tar.gz"
  sha256 "8c2123665abc24751ddcde97df2ff57834bdcdec49f76e2142a831d04306cdfe"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b7e190055ead24085346c1e5ce5e6adf989caa360aab237099963b715ca85cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b7e190055ead24085346c1e5ce5e6adf989caa360aab237099963b715ca85cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b7e190055ead24085346c1e5ce5e6adf989caa360aab237099963b715ca85cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c2d3c8ff6fb3be1b12a984ca27a23095400695b8be1e2721482b28d033cd0276"
    sha256 cellar: :any,                 x86_64_linux:      "9d1bfcd543bdbc279632bc2cae40ffa293c11ae3e7ba28b7ebd9811836a47c50"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
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
