class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitweb.torproject.org/pluggable-transports/snowflake.git/snapshot/snowflake-2.5.1.tar.gz"
  sha256 "1e8bbbb821ccbfa93c44349918532e0a800be0f6ffb086b189f98c1f04426a48"
  license "BSD-3-Clause"
  head "https://git.torproject.org/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18e2b7350f42e8d50a23cde2f6a629632a307e16a1b5b79e84886a7c13bdbdba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b53d2458b80ee8c5ac2ce0dc5b228e39c9cda3c30cc96457a9082248e4458552"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec332e2951aadfa1d86764e5eeb3608d1457db3ae5d5cab7596f9341b8f9d464"
    sha256 cellar: :any_skip_relocation, ventura:        "1794d879a7caeeea796f266eb427233843fa577caf03909b0c904b719765c41e"
    sha256 cellar: :any_skip_relocation, monterey:       "7ec936d5b9f0bfb7caef803dc14ed3eb6c3197fce2021f20272f1dc58883e004"
    sha256 cellar: :any_skip_relocation, big_sur:        "e07421cce69c8fa462114fad4aaf7c7070f752fce94268111185b5a0a7c64687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "123158a0fe99aab46db613b785a1d67213dce4e2077d0a049f93d351ce99a928"
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
