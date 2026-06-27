class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.14.1/snowflake-v2.14.1.tar.gz"
  sha256 "39aa853c9bf966ac606456b4f357631470b4bee970e256a20eab54cba8a55d2f"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc1f71e2993bcd27151c938f6cada20bfcff8f1a6a58dfb7a0a9ec0bdf60e1f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac7a90e323524b1d291dcc594e746d301c5e0017642d70060a3faa49fb149c35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffab7ef18487e71921bbea3522e9c69aa860b9a60c1d14e881283bbb948d6af4"
    sha256 cellar: :any_skip_relocation, sonoma:        "084a3e608bd21ba7c9ff050dc9aa2e7e8df9e7ece33834bda243829e1c9f8e78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e9e3a0425f1d3414fae2923434954f81f6b804f0f9b70a47d74570822f83f9e"
    sha256 cellar: :any,                 x86_64_linux:  "1b7d88490a8ae852e4863b69b9cf9662f059912f5ed77f25c17af4fe25eddf84"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"snowflake-broker"), "./broker"
    system "go", "build", *std_go_args(ldflags:, output: bin/"snowflake-client"), "./client"
    system "go", "build", *std_go_args(ldflags:, output: bin/"snowflake-proxy"), "./proxy"
    system "go", "build", *std_go_args(ldflags:, output: bin/"snowflake-server"), "./server"

    man1.install "doc/snowflake-client.1"
    man1.install "doc/snowflake-proxy.1"
  end

  test do
    assert_match "open /usr/share/tor/geoip: no such file", shell_output("#{bin}/snowflake-broker 2>&1", 1)
    assert_match "ENV-ERROR no TOR_PT_MANAGED_TRANSPORT_VER", shell_output("#{bin}/snowflake-client 2>&1", 1)
    assert_match "the --acme-hostnames option is required", shell_output("#{bin}/snowflake-server 2>&1", 1)
  end
end
