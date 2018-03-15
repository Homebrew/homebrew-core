class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.33.tar.gz"
  sha256 "7f6f5dc6444bc651ac635c81f4745bcce581bbd1d45ed60cbdc4ee11bebb10f4"

  bottle do
    sha256 "d9cbf99f24299626a110270cbaab5a555399368afd4df7d2fd3ada196b0e6f0f" => :high_sierra
    sha256 "64e9baee404e50648e14329742153afc78ecab4d66988d99e0482018de0f7024" => :sierra
    sha256 "610d953751f4e0774043b34c961c36475444981e9d9ded7791d2f9d6ae5ce4dc" => :el_capitan
  end

  devel do
    url "https://www.tinc-vpn.org/packages/tinc-1.1pre15.tar.gz"
    sha256 "41dc3e40c5f8be497b779acd6f59ef4572e1430d0d0f0436f2de5cb21a59ef18"
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
