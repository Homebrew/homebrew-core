class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.8.1/snowflake-v2.8.1.tar.gz"
  sha256 "4272cdea61107792d8a7098063447d65ee3d27f71e9ba222e414bbcfafe11560"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4eb320f9aa3ea5d81df5de25b64318ebcdf61ea8ceef71ae702fc127478d00f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8257f5f255d66ab12137998dfb01a2813d8e7d47f363cdcad8023e82213ad0f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c960945c87ff662899efc10b1c8753655ae5769480cec317decf0fc95635ea7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "77a225713b63c5019717489c8ac3c50895ca84c0c3cfd0dbe372b602d56c8bc5"
    sha256 cellar: :any_skip_relocation, ventura:        "d21db09a8c54ea9b31ee6f411a85f6c4b7a0d9f300eba90096fedd9da8bdb1d2"
    sha256 cellar: :any_skip_relocation, monterey:       "54f758ddc1df42c9491b482f0f97235aeca0d6a396d013dbd8c6f89c3d002948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c268594a1e54dddff8e132e05a6565eca83e0d1775e54da569faf6be1a291f97"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"snowflake-broker"), "./broker"
    system "go", "build", *std_go_args(output: bin/"snowflake-client"), "./client"
    system "go", "build", *std_go_args(output: bin/"snowflake-proxy"), "./proxy"
    system "go", "build", *std_go_args(output: bin/"snowflake-server"), "./server"
    man1.install "doc/snowflake-client.1"
    man1.install "doc/snowflake-proxy.1"
  end

  test do
    assert_match "open /usr/share/tor/geoip: no such file", shell_output("#{bin}/snowflake-broker 2>&1", 1)
    assert_match "ENV-ERROR no TOR_PT_MANAGED_TRANSPORT_VER", shell_output("#{bin}/snowflake-client 2>&1", 1)
    assert_match "the --acme-hostnames option is required", shell_output("#{bin}/snowflake-server 2>&1", 1)
  end
end
