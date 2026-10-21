class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.15.2/snowflake-v2.15.2.tar.gz"
  sha256 "1646f8e61a72cbb07d4556289182078d60cdd40c6399af2f32986b8206565ec6"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e84394203373694533b6beab6808313a57936d28a240b3e75f3c368361fca0bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "634b916bd566940c937f4ac7ac3a0e8f1e7e6b22562b95eb9f6406cf931b153e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c16b8dd7be40c15c60004226d55cdafe33786bfc15ab35e3616ab5553ffbacbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "96ad3b852b760e51b1a76e4ada57960ea61cded8aca343ee295c8bcd536b44a2"
    sha256 cellar: :any,                 x86_64_linux:      "b5ca52dda6f423a1468752a53162123aa62380fd893599759f1f18983aa22763"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
