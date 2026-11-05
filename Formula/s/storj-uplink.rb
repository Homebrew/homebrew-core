class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.166.1.tar.gz"
  sha256 "3b6d25320462b9e26769d0365adeeb7aedadcbf87791aa7cccedd4a955e54991"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d3271e14fae5949ad9f596fae7fa97e250ad80c3beb228a1b2cbc58b7869443f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d3271e14fae5949ad9f596fae7fa97e250ad80c3beb228a1b2cbc58b7869443f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d3271e14fae5949ad9f596fae7fa97e250ad80c3beb228a1b2cbc58b7869443f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0bc91204a29d23be152eb0d70a0beb078fcae8e8a764ad0bdeaeacd8fcc7b50b"
    sha256 cellar: :any,                 x86_64_linux:      "bc7f3695c7f392636883974b742396e7797ee0f6eb62b3b71ed7ccc020ad0de4"
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
