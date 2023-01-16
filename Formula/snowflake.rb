class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitweb.torproject.org/pluggable-transports/snowflake.git/snapshot/snowflake-2.4.3.tar.gz"
  sha256 "18e9bf5c650392e4849ce04a3945ea599f2eb7cbf2c4f0a291dc4741de72123f"
  license "BSD-3-Clause"
  head "https://git.torproject.org/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8248eeab4ab9c2100bdb235fe304245ffb3010c655578a0fe05beae3a1c37322"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecc6facd24052def5fd89b81bdf8074f59abf308f5d75a107d0150bc1d420341"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c114efd86dea93354ac2697a606f9dabf2e5ece0da3cc6525209f626bd52b675"
    sha256 cellar: :any_skip_relocation, ventura:        "cb2bcb546f01c1e67898472305a3334746303d3355d51fabf90dee95c6f60b91"
    sha256 cellar: :any_skip_relocation, monterey:       "ce76da15fc8d620c0e6b69bfeb412790c8dc68e23772c48bdd23b7dab8e0521d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dab725e33f2874704c15f2d0d3378fec0a8de1440d2d6675bbaba0073b37ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01e81fa869a654760267a4885b357e9989380abbd11167a23e28f467ccbdcc3c"
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
