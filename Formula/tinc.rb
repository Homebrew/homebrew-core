class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.31.tar.gz"
  sha256 "d3cbc82e6e07975a2ccc0b369d07e30fc3324e71e240dca8781ce9a4f629519b"

  bottle do
    sha256 "0b2cc9de63b355dc50c709e234181ec6175eb0ef81d8b6074465dfe180e1deac" => :sierra
    sha256 "fab217e8cc5648717e63bbe767989b9441f8f2c89f34bddf55832bfdc9f36147" => :el_capitan
    sha256 "6a84961dee99c13355d9e5f24a0908440f4c692b8619a5657a48aeed9e13842b" => :yosemite
  end

  devel do
    url "https://www.tinc-vpn.org/packages/tinc-1.1pre14.tar.gz"
    sha256 "e349e78f0e0d10899b8ab51c285bdb96c5ee322e847dfcf6ac9e21036286221f"
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
