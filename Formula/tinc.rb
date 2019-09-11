class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.36.tar.gz"
  sha256 "40f73bb3facc480effe0e771442a706ff0488edea7a5f2505d4ccb2aa8163108"

  bottle do
    cellar :any
    sha256 "ba34dc41517f617c4d61d61e2f76cbafd9b75aa5edacc894e5b24e97cfb269f5" => :mojave
    sha256 "a5ec2ae5f1e6252f80f33158bb0a1140e29764ed1f2e8754dcedf50e4fb49290" => :high_sierra
    sha256 "923b15d1dcd7aafbb566f83edc9cced61b13379e857243bbe28b2755270b542d" => :sierra
  end

  depends_on "lzo"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/tincd --version")
  end
end
