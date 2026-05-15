class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.13.1/snowflake-v2.13.1.tar.gz"
  sha256 "3102c0782422205f6cea7609ab67cb5fd080e048880712ebe0c85540138cc09f"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e9d502d18291cff25a1d6fb8873cae776a88b31d2d70024be8071fdb7df145c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea6144e621813d0e449e08c206e20f378b751cabb4f3c9cc6bd45e00cc59aaf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f62bf084a5afac0481c4699638d1fc1eb00bc7af281f8b1a65b90cf010890a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a5a697d1e4ab2dcd05a9915b9f0f0c6fe9c571f322e8a3e89854abdbf98972c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e30f2bbe0e0ac44b57769a4445b780cc636fd93618065860efdd954311a64afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cd412a0d820bcc5fb1d9448bb742275c06cce9ef54a9fb3359202cf41928450"
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
