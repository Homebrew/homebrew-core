class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.165.3.tar.gz"
  sha256 "4991c1d5314d9a8932efdfc51674dee0870a35c07cb8be6f9798e8f8419c8ac3"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a6a166bda008ea670290df9120772964c6c42c608f4a1fb61ca2d0442b4a6241"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a6a166bda008ea670290df9120772964c6c42c608f4a1fb61ca2d0442b4a6241"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6a166bda008ea670290df9120772964c6c42c608f4a1fb61ca2d0442b4a6241"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "be5cc4f6a446b58b8cc1e6d76a7c33257b8464efb2aba1e9c8a4c412b0ead4be"
    sha256 cellar: :any,                 x86_64_linux:      "292270409a7046aa6743cc8298a1aec3879a097231edb771fcf703fc26a71b3a"
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
