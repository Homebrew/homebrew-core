class Sslsplit < Formula
  desc "Man-in-the-middle attacks against SSL encrypted network connections"
  homepage "https://www.roe.ch/SSLsplit"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/droe/sslsplit.git", branch: "develop"

  stable do
    url "https://github.com/droe/sslsplit/archive/refs/tags/0.5.5.tar.gz"
    sha256 "3a6b9caa3552c9139ea5c9841d4bf24d47764f14b1b04b7aae7fa2697641080b"

    # Patch to add `openssl@3` support
    patch do
      url "https://github.com/droe/sslsplit/commit/e17de8454a65d2b9ba432856971405dfcf1e7522.patch?full_index=1"
      sha256 "88d558dcb21b1a23fe0b97f41251e7a321b11c37afd70dd07ac1a2d6a4788629"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "53f72ff40afcabe474f6e713fb6dac04bd7c87fcb1bf6ec91638645b7b62237e"
    sha256 cellar: :any,                 arm64_sequoia:  "5696431080e31e8d974ee9b41e2380690b0ce415deefeee3d71350d1d614706d"
    sha256 cellar: :any,                 arm64_sonoma:   "a78baab2eb804a8825d8e32e7b196ba855c020f95e82b2f3d97791f57ed6f6f8"
    sha256 cellar: :any,                 arm64_ventura:  "ad6eef71652050dd7586ca130538d612f71d6e0486a5c1b2b9eb98e5d0675e0c"
    sha256 cellar: :any,                 arm64_monterey: "dba0a5403a541ff22b1e63577de39af59c2bdfa4ea43536664526efd4c10b479"
    sha256 cellar: :any,                 arm64_big_sur:  "9a6bc8259feb162971310ab7cbb802a6d792c9a13684d756c74f2e4c12f91527"
    sha256 cellar: :any,                 sonoma:         "5ecbf858d101619382213826f91a12b0585d6fcf8aa5be655cbc1e2952565436"
    sha256 cellar: :any,                 ventura:        "6b5c5082caa1b33a2ec68d438965ef1c405404b8808ca1fd9cda7397ac366165"
    sha256 cellar: :any,                 monterey:       "5f23f06acb83de8e1730a267b0e543e5a2b46af6ca0021922fa2e427c8eb3cdb"
    sha256 cellar: :any,                 big_sur:        "5609fe01116b26aeae02e483354ab84a4b9cb223095618640c32af5bd7341cca"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "69b100b3bc4a6279bbef5d49cbf4f44a2085ef1ec03a5872f85a7606f5e667d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e62ef71e9d154f54fac451123377ad0c59d103b544386b4100ecb34da2ad2cc"
  end

  depends_on "check" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libnet"
  depends_on "libpcap"
  depends_on "openssl@3"

  def install
    ENV["LIBNET_BASE"] = Formula["libnet"].opt_prefix
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    Open3.popen2e(bin/"sslsplit", "-D", "http", "0.0.0.0", free_port.to_s, "www.roe.ch", "80") do |_, stdout, w|
      sleep 5
      sleep 10 if OS.mac? && Hardware::CPU.intel?
      assert_match "Starting main event loop", stdout.read_nonblock(4096)
    ensure
      Process.kill "TERM", w.pid
    end
  end
end
