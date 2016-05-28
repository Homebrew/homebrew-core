class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://tinc-vpn.org/packages/tinc-1.0.28.tar.gz"
  sha256 "0b502699360f09ce2128a39cf02abca07bfc699fc02ce829b3a90cf5e1e8b344"

  bottle do
    sha256 "028353499ec60475476a59643463ab35cbd562c352b00ed6700b7e9ba8748a15" => :el_capitan
    sha256 "2985e4a5eb9784448887857ed7ae3a7dc0ef9df4505d3592dec865f6f9bbaed0" => :yosemite
    sha256 "0313b51953e300bf60c87722c8432c902c20d6b0fc484a03dc5796e3bbb87b6b" => :mavericks
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
