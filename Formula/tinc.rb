class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.34.tar.gz"
  sha256 "c03a9b61dedd452116dd9a8db231545ba08a7c96bce011e0cbd3cfd2c56dcfda"

  bottle do
    sha256 "d9cbf99f24299626a110270cbaab5a555399368afd4df7d2fd3ada196b0e6f0f" => :high_sierra
    sha256 "64e9baee404e50648e14329742153afc78ecab4d66988d99e0482018de0f7024" => :sierra
    sha256 "610d953751f4e0774043b34c961c36475444981e9d9ded7791d2f9d6ae5ce4dc" => :el_capitan
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
