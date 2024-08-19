class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.9.2/snowflake-v2.9.2.tar.gz"
  sha256 "b539a069eb3996d20a63eef9af59b43adb740ea121c954edf13b2bb6102b7112"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca4bc60a204d685d9f055fb76134cdbe2e5c1f1399e50227547f56caa3b85cdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a6b5141e343ba5f4a85c4f936ce19ff3d3e457db142a5b80d02053c24344d98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9fdc390563164a85da485c593b98ad7c6d35c3ac5dfa4b19fa61f6109f6b7a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d7940dae0defa29dccdb11202b6d68344d6224f62670bb3ce88ebf67ea9a4e4"
    sha256 cellar: :any_skip_relocation, ventura:        "87a1891c2221c92a2b67d759201714f3eb249c3989a180633fac1b5272ce3919"
    sha256 cellar: :any_skip_relocation, monterey:       "401ac191227baece24a1813fa6e10d606d922d0ac2d09d7efe5bd375bdbaf8ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8247de66b9316abc691f84bd22c523f856a2c04bf533a2e20e5f5936020d67a"
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
