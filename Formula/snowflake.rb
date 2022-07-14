class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitweb.torproject.org/pluggable-transports/snowflake.git/snapshot/snowflake-2.3.0.tar.gz"
  sha256 "12be2ab46b174b7a72c7261577f5a89ca301f232e5ff100ef771375337a188d3"
  license "BSD-3-Clause"
  head "https://git.torproject.org/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "158fcc636e9f65f1c768d2eba743aa068dd0cc78ac5d65f7d6119e025f719161"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54b06a05f91cf300625badf1efb7e6dcde9361d24b401fe787dd9c97770aec36"
    sha256 cellar: :any_skip_relocation, monterey:       "e9071fb2ddc7ebdc89e3d398842be1b8710c6839de51b7203409fc5a66a6e10b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf503f6ff658f72770216d5bbf0347f7c912ea9bb1ade2e50037d6c2a0208965"
    sha256 cellar: :any_skip_relocation, catalina:       "a3b47e2662ac5bc4d62bddb9452a22b7d5d5d20740f1c97d97cffaf6783178b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e829e1bd035833e3824a3159882d0a29e7a03d70a217dd48fd06db245412b7a"
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
