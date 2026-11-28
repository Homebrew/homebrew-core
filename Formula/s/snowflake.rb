class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.15.4/snowflake-v2.15.4.tar.gz"
  sha256 "eccdecb99db4bdb2f32d5f4988e97cb01b4b0c4ccf1a67f29b84d81bdf34f3f7"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    manifest_sha256 "122a261cd4fb4bb031d1dcef8753c7236f2e3534b339003dabc91948b5ea5f2b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a856a820881b2916c5858285bfc1b238da2b693096d4571ef6dc3b0c5e1cfc9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "41dd8d1e53967cba6e00993e7e589eb3bba47c135e2832945b5ef1bf5a459dd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d09e0025fb7a90e4f305bad743f801b007fc2e5e1daad7a8125b23abcc001dfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1996db77ca2d46ee45619b86f90c5f886a943c46a46e4ca8689a2be74fa9759d"
    sha256 cellar: :any,                 x86_64_linux:      "3e1de001964ec90ecc9dd6f2461b3ff266e796a0f34f4c6ea533b4aea7f89a2f"
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
