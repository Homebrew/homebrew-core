class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.31.tar.gz"
  sha256 "d3cbc82e6e07975a2ccc0b369d07e30fc3324e71e240dca8781ce9a4f629519b"

  bottle do
    sha256 "ec9fae41ccd13d09d685af092c9d18ccbffccaee0aeaf66de18f794f8f85347d" => :sierra
    sha256 "14676c91ce92ce6fb0cb351a06ec920e8b45ad0a1f32867152778f5299b1ef38" => :el_capitan
    sha256 "440be633f66aea7ee705f2ddad9344ea20201128b98d27fcf5358fd5641e6a4d" => :yosemite
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
