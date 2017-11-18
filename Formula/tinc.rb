class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.33.tar.gz"
  sha256 "7f6f5dc6444bc651ac635c81f4745bcce581bbd1d45ed60cbdc4ee11bebb10f4"

  bottle do
    sha256 "cc379d3508fd99fdc4c86849eaccbe4ca3a3b9f776d452c9d6b12371d5c253d3" => :high_sierra
    sha256 "6345debc1249e4630ce3492d39c2e7ac6c8ccf51f38004c68f3b1cbe715628a2" => :sierra
    sha256 "3a24d224c09e29969db5f60e792bfd42275a7003678abec5567f7e45ef210057" => :el_capitan
    sha256 "163e958fca8bf041a7ca89c215399fd06e1e11c29136080f03c5fb249b18ab36" => :yosemite
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
