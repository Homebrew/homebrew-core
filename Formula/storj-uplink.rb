class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.64.1.tar.gz"
  sha256 "691a9b10a9e723f73a23d3bd5ece14ab9fc4ec571a58fabd8b2952388aabf56d"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62806ad514d5b95fbef1f2ab0899a299ef26ec252b7451141c6ddb0f05c40c84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0cff79838299dfd8b6ce4095b345565a5d30447ec403431ffc16964a98779f7"
    sha256 cellar: :any_skip_relocation, monterey:       "fd4c01bb726888be6b35ab47e3b851985f97521291a5d2d367b0bd446b1c3602"
    sha256 cellar: :any_skip_relocation, big_sur:        "e507847c5b5c3c76d625d6cdb24cd24752fc6ab2ac3550de51d5a10a4d6b1e3c"
    sha256 cellar: :any_skip_relocation, catalina:       "92123ae36d453392ddf1f78ec6bace132a509e94767dc413e63f09262debcc97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b38252ca89945357159b2adf24e3051bdd3c4e5b6bb3fbd137e56eb59f37be4e"
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
