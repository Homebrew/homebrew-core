class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.10.1/snowflake-v2.10.1.tar.gz"
  sha256 "fd3a8036d1a94bbe63bc37580caa028540926d61a60a650a90cab0dea185c018"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07a6b122106aef0f5d9937284eee382799fdfff93618403f9c4a865810323128"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07a6b122106aef0f5d9937284eee382799fdfff93618403f9c4a865810323128"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07a6b122106aef0f5d9937284eee382799fdfff93618403f9c4a865810323128"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e0692f785c995c5b510a8cceaecc976d0a006a1c1106f2f3c18afefe6b490b6"
    sha256 cellar: :any_skip_relocation, ventura:       "6e0692f785c995c5b510a8cceaecc976d0a006a1c1106f2f3c18afefe6b490b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5748cac0c4def26224081230df4a1054d992796b11dbd91453ac196ecc1eca69"
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
