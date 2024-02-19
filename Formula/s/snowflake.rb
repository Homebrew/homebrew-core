class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.9.0/snowflake-v2.9.0.tar.gz"
  sha256 "7a58e8006e6716249741917e0d58a70d07e15a8b3d7f10737c8bb4a1134b5e8c"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bff48f83868d6a4d5933abc99805d566c4ebc9207802a56284c1157726bf38b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85005b08500abab9f0df44f3647c8df6dede6ab45af5fb0edc9b0e5064f649f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "136611d07fd7337ab4aa65b8e99d35485b6ac3ff27f4252e8985956c5e2caa26"
    sha256 cellar: :any_skip_relocation, sonoma:         "5cc87cb9b690091c64d384557c0b1b97257af89917536da820624de8df050a66"
    sha256 cellar: :any_skip_relocation, ventura:        "870df28980252130de470fbfc7287bc6764024e4f3eff85388472eb5a9c002ba"
    sha256 cellar: :any_skip_relocation, monterey:       "d0cbb18f70206a4dd00f4581e4d44fe2545a3cf11683aaa2a54cba3596dcb1f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbd9fa03d0092ce94f0c93fc585f66de28e397cb88ab5201d0cf114c16fb8e40"
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
