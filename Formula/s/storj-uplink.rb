class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.98.2.tar.gz"
  sha256 "57440ec976853964d4a4c7102eeedd8b2703c501a13b78a10d04a47d0658c4b0"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63f6bbba48141314aef99b5c26d6e7b46272d089c70fe4681e81d198aedc9517"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "179e01e06ea07fc768266f6c1a25b7768c5088d3eac8f94915c5ac92d2d361b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2ad70f434beb7c02bda22295e118abb8c897380738f0daf980483ebcb174e14"
    sha256 cellar: :any_skip_relocation, sonoma:         "72387583f4e1f6e82b6b2d11ac18fb42b07bc1328821ee7a1607a574c42ee24c"
    sha256 cellar: :any_skip_relocation, ventura:        "a7fd64443167a46d7496956b270cf5dc92c5ff068b5ae6d4b92e97fa9fcf2363"
    sha256 cellar: :any_skip_relocation, monterey:       "6b2f348641a4ae936c71ae3401267124a97fefc0cbffa12addc474d01e8e13b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2223a1e7e9efd1485e1ae5ee29ab56b5528c6e82cd5457e606837babce293015"
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
