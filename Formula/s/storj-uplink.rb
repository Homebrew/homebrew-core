class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.158.3.tar.gz"
  sha256 "cf5dc7f7a2b41a284616ce0ff265f2331d45f05807ca7f5d3df7cb660d0960a9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0accee39a62365a4080854c0d881dd53b9179a9a3f2b574c34287357aa9c4d7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0accee39a62365a4080854c0d881dd53b9179a9a3f2b574c34287357aa9c4d7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0accee39a62365a4080854c0d881dd53b9179a9a3f2b574c34287357aa9c4d7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "49efde9151b8bbf68c784d409302c5b353b0afacb0c55006e69f6f2a537502e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56604e2b00dbeb8859cee1a7dcd1457a1e8f2dd417b90468516c7608bd51d76b"
    sha256 cellar: :any,                 x86_64_linux:  "db2ac74cc96b83f26c78daece01408f2e3bfec9db0b74838e1366cc697682cb5"
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
