class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.12.1/snowflake-v2.12.1.tar.gz"
  sha256 "655f1daa9af141264c159ce0fe79070d7a4ca46ce43e94af2218a67f826d22d5"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "312f4651ebff6ed9096066a3cd6b359c02d3a323da66b4cfb279cf73b843c338"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b46893061a63894bbef1baadee580f294511875a8cfbfb4b3ac957695ddbdc74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dda0b235365876cca07f02b3d5e30875f8fda7ea97529c7034069af9eb5e8d33"
    sha256 cellar: :any_skip_relocation, sonoma:        "693ff641bf1f2b20db14ed48b68ea79538e78e95c49538b799ff3b3bfbf9cac2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00460f3cb64d1826f1c0d83356ac6e46511c2cab59128ea138583ecc704482eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9c729cdff9f93a9ac4c094ca81dd31633c33e1133c23a36103ca92073a7c331"
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
