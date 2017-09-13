class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.32.tar.gz"
  sha256 "4db24feaff8db4bbb7edb7a4b8f5f8edc39b26eb5feccc99e8e67a6960c05587"

  bottle do
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
