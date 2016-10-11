class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.28.tar.gz"
  sha256 "0b502699360f09ce2128a39cf02abca07bfc699fc02ce829b3a90cf5e1e8b344"

  bottle do
    sha256 "0d06196ab9497b7e74db17945d2cac278ac735e7c6195a57587f19b325be9428" => :sierra
    sha256 "84592a1250acece0fc21b2c03484fe918cf4d2a4375cb9018aa2da307c060092" => :el_capitan
    sha256 "d6ca2c9126af268e056596a7965810145ce238c91f17bfd44d2321f51b2f856a" => :yosemite
    sha256 "d1bed931803d781ab72412f47e1d13e63649547b12e6801a7f7d0ba834ccffd3" => :mavericks
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
