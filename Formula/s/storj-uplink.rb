class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.104.1.tar.gz"
  sha256 "b497662833e061aa2c1cf1e7ea401ee11c10ed636490d6984468e8d53d85ebc4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e315c63f08b5a67bf51ec00bebc6450c7284e96d211c4672cd0d9647f03690e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50887601e79656ecedc3199aead2bfb3a0eb001da8ff284396f5e3bbae41b0c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddfe41b786fc7441da98c57434b691aaac5ac058be2fd7bfc1e643bfc8cc7dc4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f312451f273c48cdc5a0c9f510c0803d9ad6d364c5ea796d6c37a37ececa8e05"
    sha256 cellar: :any_skip_relocation, ventura:        "ade870a97790c87680bd2a1c450e046f0b1a8889a330f5572fa941984a88d1da"
    sha256 cellar: :any_skip_relocation, monterey:       "85bb9386a34fb11ad34bf8cf386a99c09e8220b9a206dc0c76cf2950ad1859fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "273b315a42353a87bd235ef596218dbd5550b231110882ae7788c5abe50e086b"
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
