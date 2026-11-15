class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.15.3/snowflake-v2.15.3.tar.gz"
  sha256 "a78196e776297ef127122a84d0be691ec978d8263bc97f773e553be042632e57"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d052b2b93494d8dc7a8b2d4d1d746477429356d09e9169d3f659cc578558f0b2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ebe0ab1d18579a2b3e4c6f87df5586b103992c8c1b413cc5146c844b09aa6f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f02213b074f37600b7f959f31aa291b815bbcb2a7b4a1f23782e91f10503104"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4d7afeff521fec223a8525ad2fa0071671678ac8c4de2a02761fbff0f981f332"
    sha256 cellar: :any,                 x86_64_linux:      "9f9c2cd23beb897fcf12323db886e9037b1ef24f872691986b6b2d861230e51a"
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
