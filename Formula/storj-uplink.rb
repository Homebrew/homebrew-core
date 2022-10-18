class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.65.1.tar.gz"
  sha256 "05dfedab488e44aedb7d8d35ce9565fcb622b86b474b4613534726acaa9efccf"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41a5c99f324cf3d6a68a0cb234d33457b753f465cfbf4b34df2daef8c67d84ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d02d9b298a5c7bf98067eb99d793d0fd768c5cad496fc0c45b0012296d23bf49"
    sha256 cellar: :any_skip_relocation, monterey:       "bb3e76cce1ff4114018adcd011fd7974cea6eaa3402e9d00c4e9c0b61de56c36"
    sha256 cellar: :any_skip_relocation, big_sur:        "e74e5507835e4c56eb91442700b7cd2b1dc7a601d631d7ec728edcdd2f1b3502"
    sha256 cellar: :any_skip_relocation, catalina:       "8ba8157ed08673c682e121a8fdf417866d1135366ef51984dcabba3b57d9ca62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d2c2c9956314a087b6ded268c3a578b8a7d04d607296ec4b4d979b26decb63d"
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
