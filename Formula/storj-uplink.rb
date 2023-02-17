class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.71.2.tar.gz"
  sha256 "74e70f180c258f58c9e048d24e4e6a2ac4d71240d342d942ee6255cfe2827418"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6274cd5ff5dc3998bf81b485c004221db0d7deccf23b4c66c5e781d0e3c053bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7edea6e14f6b37a4d884ed5467a48d2242a6bc90b2711147f7314eeaae398cb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c42fb428d8346712144c87e777d0de444fcf86c0657ed84fb494c73e2c4e0bf"
    sha256 cellar: :any_skip_relocation, ventura:        "15cbebb0d59eb7e10e0640978581d468cd262277a68eb1634092fdf05adb046d"
    sha256 cellar: :any_skip_relocation, monterey:       "4be9cd29020f440de7852c2a1c04ddec61701f8a18dea70de4963579f8e1e8d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1efc1168f6163a8a0a8beec1c15294c082382e0a8efc6f48d3777fda27c6042e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "226057ff620e59eef120705deed1c484c0b011ca102519718a52d530c001878e"
  end

  # Support for go 1.20 is merged upstream but not yet landed in a tag:
  # https://github.com/storj/storj/commit/873a2025307ef85a1ff2f6bab37513ce3a0e0b4c
  # Remove on next release.
  depends_on "go@1.19" => :build

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
