class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.34.tar.gz"
  sha256 "c03a9b61dedd452116dd9a8db231545ba08a7c96bce011e0cbd3cfd2c56dcfda"

  bottle do
    sha256 "2d8034404d514f18b2d09b2ded4ac524ca6a65adb4dad695611cd870aa906e12" => :high_sierra
    sha256 "fbfe414a6f1c0817b56743d8d255008cf6070f41ca25d9216c8ecda24a92aeb1" => :sierra
    sha256 "6a187d24923ec9dd02162f6e0484c3733861a9783b5a1d21378475a0ccb82323" => :el_capitan
  end

  devel do
    url "https://www.tinc-vpn.org/packages/tinc-1.1pre16.tar.gz"
    sha256 "9934c53f8b22bbcbfa0faae0cb7ea13875fe1990cce75af728a7f4ced2c0230b"
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
