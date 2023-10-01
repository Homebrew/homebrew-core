class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.6.1/snowflake-v2.6.1.tar.gz"
  sha256 "e232e389ceec36fab60171b544112317798784ae8c81eb33ac9525649f8513c9"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72d99e1bfb962ae79cf35b7e67135e5945ed2903ad75bf05c2ca351ca1269d1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5656c01c1ca02275ca79f7dde02763a456da78bf470dac774241705209ae178"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8a6f1457638be62aca8879d08ce2df82ca35f0e4aeb7b0095e69b8ceacf736d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fedf6449919022da0f591bdd5d69b4759fa7f4651c00890e6c4a2d0f3c2e3605"
    sha256 cellar: :any_skip_relocation, sonoma:         "251679a0e79c52481d3cb513842c62eefbcddb8e92f0a3843047720f6e100dc8"
    sha256 cellar: :any_skip_relocation, ventura:        "bcb24ad42718d2c8a31e223a04b40035fb3f8458cd92427ec6f6f943c67e922e"
    sha256 cellar: :any_skip_relocation, monterey:       "c7fb45bdc8a866349bb033fe011438d5bf3e2ac928f74e08d8e128ee449d4710"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1a429d665216d2ab83b7160b7b7ba591405124dbeca4ae687d2185a13458829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f975fa34b36c47de42363ecd208734559f601d0c6e923c88793276714df39a93"
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
