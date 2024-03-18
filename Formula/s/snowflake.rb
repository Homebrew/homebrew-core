class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.9.2/snowflake-v2.9.2.tar.gz"
  sha256 "b539a069eb3996d20a63eef9af59b43adb740ea121c954edf13b2bb6102b7112"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0402d2a97799ffb633c08610f9e32387b666aa2395f9512527c7c5d64039339"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2e477c7473801fb8c04c07b7c329860b159fee39e220de90e19827d2362f72a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56515cf7a2db6560703a09ab7196e917c8ef87468418a99e2c488de139c1aed0"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a52eddbfc53cb3ad2c31f037bbb9e6f8125da610a0839ab9114cf7c21ee606d"
    sha256 cellar: :any_skip_relocation, ventura:        "0c34a4d3673dd56a05257f5a59e4b38e59eabbc0bfab2cc75a5fb2a1151df397"
    sha256 cellar: :any_skip_relocation, monterey:       "e622fa31088b078ddbaae868309f326aa8c79b8e70b3df9a3ec2c13f25f80314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fd1e4b05e4a7aa1bb65e303634ff1dd91c6d0242c026ba39b82449cda462f14"
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
