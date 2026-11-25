class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.167.1.tar.gz"
  sha256 "339875607e89f5090b46cb599015408698357d3674ee84ce4df3fa28ec52aad3"
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
    manifest_sha256 "7cc157d33bf82c8f06630f0512e7b196fe309d6612fd07e86639cd0203f872f4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ae7f8f699d2976d5dd0be9115faf23fea1f242d00d65e899c6b2271b1487594"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ae7f8f699d2976d5dd0be9115faf23fea1f242d00d65e899c6b2271b1487594"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ae7f8f699d2976d5dd0be9115faf23fea1f242d00d65e899c6b2271b1487594"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fe8e8eb664ece4f998e1087d329c07bcc2017ba3a133cd1e02b9396fbed41d1d"
    sha256 cellar: :any,                 x86_64_linux:      "fe5506481e825838ec917705997b58fbcdd52f7b3125bd1df9f73adee667bbc3"
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
