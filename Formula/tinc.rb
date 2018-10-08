class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.35.tar.gz"
  sha256 "18c83b147cc3e2133a7ac2543eeb014d52070de01c7474287d3ccecc9b16895e"

  bottle do
    sha256 "17c04d02ac29ebf6cfde343649056d8007892b267f26b50128c6eabcc48f107d" => :mojave
    sha256 "2d8034404d514f18b2d09b2ded4ac524ca6a65adb4dad695611cd870aa906e12" => :high_sierra
    sha256 "fbfe414a6f1c0817b56743d8d255008cf6070f41ca25d9216c8ecda24a92aeb1" => :sierra
    sha256 "6a187d24923ec9dd02162f6e0484c3733861a9783b5a1d21378475a0ccb82323" => :el_capitan
  end

  devel do
    url "https://www.tinc-vpn.org/packages/tinc-1.1pre17.tar.gz"
    sha256 "61b9c9f9f396768551f39216edcc41918c65909ffd9af071feb3b5f9f9ac1c27"
  end

  depends_on "lzo"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/tincd --version")
  end
end
