class Sslsplit < Formula
  desc "Man-in-the-middle attacks against SSL encrypted network connections"
  homepage "https://www.roe.ch/SSLsplit"
  url "https://github.com/droe/sslsplit/archive/0.5.5.tar.gz"
  sha256 "3a6b9caa3552c9139ea5c9841d4bf24d47764f14b1b04b7aae7fa2697641080b"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/droe/sslsplit.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "74357200610d41f36a3f2704cf7c877a3ad874ab9d1f032d711f7045f73f4fe8"
    sha256 cellar: :any,                 arm64_monterey: "8d28aedb6e1d3750430f1016b5f3ec4a4181afbc2186174c06bae99a186b6de8"
    sha256 cellar: :any,                 arm64_big_sur:  "ccfd4cc54565e58d41ce627ab1ee785de30c96fa29ca3637c3ee6e84320499dc"
    sha256 cellar: :any,                 ventura:        "ed9f42f9154b927c949d4e3c0d00c12a6869ef734de00a2c59effc46dc646be4"
    sha256 cellar: :any,                 monterey:       "29d3d71987797256fd0b5e628673701823d2aebd6d75a27316bd8e728852bd84"
    sha256 cellar: :any,                 big_sur:        "4d2d0096b82dfb0104f014f69363a34c1242e2bc32ef585466dc938677c33d26"
    sha256 cellar: :any,                 catalina:       "a533ccfc4c05e2affcfa4c697c38d995239abfd1fe4c383ffaa1a8ed42a933e6"
    sha256 cellar: :any,                 mojave:         "10534d989706ca1d29b7f1cbffc59ef07b02d0d755cb8aec5bdf9430c52769bb"
    sha256 cellar: :any,                 high_sierra:    "4f7a3cb7333641658889a55830a69d0ac64cf93dca8a6de32052d4080f477058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4d7b3870ce8a27f6040c4bd9ed85010a62d389c4ff08ab33ac1fa94adc49e79"
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libnet"
  depends_on "libpcap"
  depends_on "openssl@1.1"

  def install
    ENV["LIBNET_BASE"] = Formula["libnet"].opt_prefix
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    port = free_port

    cmd = "#{bin}/sslsplit -D http 0.0.0.0 #{port} www.roe.ch 80"
    output = pipe_output("(#{cmd} & PID=$! && sleep 3 ; kill $PID) 2>&1")
    assert_match "Starting main event loop", output
  end
end
