class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.10.1/snowflake-v2.10.1.tar.gz"
  sha256 "fd3a8036d1a94bbe63bc37580caa028540926d61a60a650a90cab0dea185c018"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89a106509860c13ecf8b2bfe11ac3e6f83c03d493960d4e9570ba61ae63131ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89a106509860c13ecf8b2bfe11ac3e6f83c03d493960d4e9570ba61ae63131ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89a106509860c13ecf8b2bfe11ac3e6f83c03d493960d4e9570ba61ae63131ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "e63cc05a0a54ca94d93bd68754ecb0629a288a34a56a378e63561d6c8a48f924"
    sha256 cellar: :any_skip_relocation, ventura:       "e63cc05a0a54ca94d93bd68754ecb0629a288a34a56a378e63561d6c8a48f924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5edb791b02ef6cf50539bcb495f58f8f2622085f81252abb17f14eeb3f62356d"
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
