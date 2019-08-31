class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.35.tar.gz"
  sha256 "18c83b147cc3e2133a7ac2543eeb014d52070de01c7474287d3ccecc9b16895e"
  revision 1

  bottle do
    cellar :any
    sha256 "ebbeab098fdaa5cb99c82e3dfe070b9b937e3fcd0bc2bf359065baa3724a21cc" => :mojave
    sha256 "69cb1d5d79d864dcccf9780f155717149b543aad9fb20169dfb512444a2d58c0" => :high_sierra
    sha256 "ed42273ffbc0b26357b8f70fc5af4a9f089d19978ef0d391f2bdbba50aa97178" => :sierra
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
