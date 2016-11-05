class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.30.tar.gz"
  sha256 "abc17e25afc1b9e74423c78fef586b11d503cbbbe5e4a2ed323870f4a82faa73"

  bottle do
    sha256 "9496e2c82466f01ab9d0590a10afcf65e789aaafb65576e89bc4dbc5614c7d18" => :sierra
    sha256 "51438e4b9772b1ece71c29491051ea199d794a8c50be483dc9d3155bd91d8727" => :el_capitan
    sha256 "9468052df29eb365cbbefb71769a8c0d368d60dfd2191f4f4f0d2319ed3797e7" => :yosemite
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
