class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitweb.torproject.org/pluggable-transports/snowflake.git/snapshot/snowflake-2.4.0.tar.gz"
  sha256 "e1f77655db895b3ec304eee029d9b7fbf205d3c6cd354a81ad20ad8c501d465e"
  license "BSD-3-Clause"
  head "https://git.torproject.org/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5358d95caeb519fd52064300cc6c03075764f965498a640dbcd37b334bef2c23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca274c6678b71d1ea47f0e5b6ee0b873a6a2826da634186225f0f0d37f2459f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2836b655208a177b5459630bab88560aed22b704d5bf2f621ddcaeec9838fb9"
    sha256 cellar: :any_skip_relocation, ventura:        "b0b242255b7355454dedfccea870eb5f3d95ff3a2bb8bee760968c20a133fcb4"
    sha256 cellar: :any_skip_relocation, monterey:       "383ca25f5e69b9f5aa9458816c4eb1730a5907de5e7fc1a55d65089cfff5224b"
    sha256 cellar: :any_skip_relocation, big_sur:        "61a06facc6a248c6590ac9d82d5ce1165cf8313a131e3c825442b7a882d0bd2b"
    sha256 cellar: :any_skip_relocation, catalina:       "bf26de9c93dfd2f49a9d9e8a37c785b41cf42eb460e786e51d4cbeec86828f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f20ca5db9a0d6d3e1fa6906a1d91622367b3d8306dd36c767a2da5a00efe0c6"
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
