class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.7.0/snowflake-v2.7.0.tar.gz"
  sha256 "69d0408905a29919940e9a3994b480dd3414f0dc177aac24e9afe9ff56495029"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "231cb179d1ae78e61ce3c679b8269c29ffdd280023573acdf1c8eacde969b666"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f688e5c1f567d5bbf607e3eeab302e2f60b9e5dccbfed5d67751f69ed09b3698"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9702cf878750dd30b2d81f5121df2a803eb0448a2971ec80771a54b17399a3d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b8484e779f8b0e84703d18590ce3aa8e76024b66bca5eeb5ab7769f5b965cec"
    sha256 cellar: :any_skip_relocation, ventura:        "3b6146f5d8675e641b8a1b7c872d19d865804b4bc49d603ebd15fb8ca89267d9"
    sha256 cellar: :any_skip_relocation, monterey:       "01ee3ae699c768a1eeeae76a23c8155e513e03a5941c1246f72e5c3df79a62e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da65e8f9690d5ad46c6f47d9d86f98f1a782554fd16bf859771715ec28c1297d"
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
