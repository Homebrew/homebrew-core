class TincPre < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://www.tinc-vpn.org/packages/tinc-1.1pre17.tar.gz"
  sha256 "61b9c9f9f396768551f39216edcc41918c65909ffd9af071feb3b5f9f9ac1c27"

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
