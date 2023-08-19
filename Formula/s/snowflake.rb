class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.6.0/snowflake-v2.6.0.tar.gz"
  sha256 "3b49ce35059fb414211263f564c7198d3562fbc49f7e16aefe6597eb948aa243"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "739f418e9400f55bd4af1a8a3e7f1cfb3d8e7aefc500709fca9a191b42311158"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "739f418e9400f55bd4af1a8a3e7f1cfb3d8e7aefc500709fca9a191b42311158"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "739f418e9400f55bd4af1a8a3e7f1cfb3d8e7aefc500709fca9a191b42311158"
    sha256 cellar: :any_skip_relocation, ventura:        "2b6705a15bb0a7eb662c366f1b234eb7d4c8c32e35f63f9dff79abeea75da137"
    sha256 cellar: :any_skip_relocation, monterey:       "2b6705a15bb0a7eb662c366f1b234eb7d4c8c32e35f63f9dff79abeea75da137"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b6705a15bb0a7eb662c366f1b234eb7d4c8c32e35f63f9dff79abeea75da137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaf0f2443639165ead60b79c8f4baa90f4c2bbd084808134cae188cb91076923"
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
