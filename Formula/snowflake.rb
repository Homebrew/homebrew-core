class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitweb.torproject.org/pluggable-transports/snowflake.git/snapshot/snowflake-2.3.1.tar.gz"
  sha256 "47e035ff08668317e719b982a924d048fad738e6081005971e895ddcc2283fba"
  license "BSD-3-Clause"
  head "https://git.torproject.org/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1111591b910c86ac7a8c045c37ae337cbddc0a1cc8de63a8f735fd06bdab3d8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05d392f2c7416ede06416960475e89742fdcea225beeab57253dd5ec919a149e"
    sha256 cellar: :any_skip_relocation, monterey:       "1f15836a855ef013487689194c0cfe2436455d5c7760ae90420dc7097e106e77"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7725e9f625de97e909213d414c288dbabf4a329901b8c4317fac886a49ba41a"
    sha256 cellar: :any_skip_relocation, catalina:       "bb6a1660ed47a3b43848d6d295b3eb6f60ac61cf48f86d9e84be98c3b93ef2ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d060708a684062e7530f3cd486ff0ded5251f75aaefefc156cc01bc49865202d"
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
