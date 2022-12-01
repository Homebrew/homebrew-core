class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitweb.torproject.org/pluggable-transports/snowflake.git/snapshot/snowflake-2.4.1.tar.gz"
  sha256 "76eff09dea6a1d63dba3984876d17a6bc1c7c38da10b770980ae2ac9b18281a8"
  license "BSD-3-Clause"
  head "https://git.torproject.org/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b1b386f296fbcd63130cf79858ddcb3a7e573ae260f925ecf26e6b21c8e8116"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14c92d54bdf129eb17d407188606e6817a88473ad0d35fb90bd124a1b4e1aec8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "398f5436e61a3655a5b1b62a7c6a98e2b37b071f4c11ee270068208eb9805ddf"
    sha256 cellar: :any_skip_relocation, ventura:        "afe041f4758d0b57f5b2eaf1357e9b37d3827958a4e672b67e8a76c85ab3b10a"
    sha256 cellar: :any_skip_relocation, monterey:       "aca68cb7a4a3043e882b48df8de88b9700b1fb12817807acd948d1a4c90459e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "47a412bf90a26a22f62a0ceefe9eabb1910daa4416abed49db56d023317cc6e2"
    sha256 cellar: :any_skip_relocation, catalina:       "57c845d632be93c7b7ba81706c289d61bb32332961a9f2461e4f50461679b36f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97652b640edf5ebc3b7fea72b59dbdd2acd98b52d3e60f3e42f877ef16d73144"
  end

  depends_on "go" => :build

  # patch build, remove in next release
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/93d8acb/snowflake/2.4.0.patch"
    sha256 "2c10cde8a894088791cf7395367aa27455140601038ba95ef24e6479e3cc0af3"
  end

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
