class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.35.tar.gz"
  sha256 "18c83b147cc3e2133a7ac2543eeb014d52070de01c7474287d3ccecc9b16895e"

  bottle do
    sha256 "98c73cd30d30b74363b2093621006361da5a8738e040d9c6bf329016d7f18c3f" => :mojave
    sha256 "9c76119b5f3116772bff828dfb3032d44d1ee6d232236789c03871cf605d9f37" => :high_sierra
    sha256 "0c78ab7901f43d6f2dd2406157308377722df4d225737fb193dcd7e3f3ef7714" => :sierra
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
