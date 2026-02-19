class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.11.0/snowflake-v2.11.0.tar.gz"
  sha256 "1362a8d7e848beea63bf4d7e6b5541df92f2859b83daaf4260afef131556ac57"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5920f2c958a7b2b3ffa409a3edd139fba2a8e7e6290846918e447ca5e725124e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbfe22d4e22f7e8bc1f433a6d9ec4e1026c8ae55eb891c2ba2257ffd98f11bea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "710d7b91f534072122a147135f59e3e8f8af0acebda38a920d94511c9c4566ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bbd8ea59d3c04b72fd131bad9da3a15ce47c007cf20b4994f201fb85f4be8ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "664910374fec0499630a0c149725965d955385fc9f31f024d9b916d474b41d29"
    sha256 cellar: :any_skip_relocation, ventura:       "1cbfef989c97ae01dc78d09692cb3157f8c7fa780bd576e9b23de4c159e0b5a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "997eec71835cafd9b1f1c1abd0448ad5e817b5315c26fd8b3d41c5d0fe93a2d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cacc65f14ee6603e2ebcc0a107b814648554a2d14657ba69127116f22999e784"
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
