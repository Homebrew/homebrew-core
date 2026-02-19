class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.147.5.tar.gz"
  sha256 "521c002bd82a28c87766a39bb7c6a57432dac250eba2d32891dd1f492fd8385b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2dd0bc3dc21da11e4d44694064698f0c1ddc74e6a4a584eaab8aacc9d47dcd1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dd0bc3dc21da11e4d44694064698f0c1ddc74e6a4a584eaab8aacc9d47dcd1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dd0bc3dc21da11e4d44694064698f0c1ddc74e6a4a584eaab8aacc9d47dcd1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8568146754dd1898c2e32e808de70b3fd8c81229086e1b6a9710507158926dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fb66ef8d06d5194ccd9bc6a2354362a08d10e498e288996d6c86e770785f93a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "148ad59c82dd33be0c053601bd983f1740e64c878906a112e2b4ba0047a2af87"
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
