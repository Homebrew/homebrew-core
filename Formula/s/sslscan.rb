class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.1.1.tar.gz"
  sha256 "ccb1ffcc97cbde5c184542debe2ac3529e2c64b3690a402b592ed4ee374955e1"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "609817a01a69046da06ac7a42ebdf99722d2dd148e4cdbabb0a3fca8e984b453"
    sha256 cellar: :any,                 arm64_monterey: "66f53276cbf5d56d752471b38a13a746fca35cacdc46fad546b2b86906b48d53"
    sha256 cellar: :any,                 arm64_big_sur:  "2f6c213950706cea1804b55ae9bd70e4dd9c8daab1347fcd8eb4edc1af011da7"
    sha256 cellar: :any,                 ventura:        "9309f17b8fae569e45942b25327a4c022fbb1db8797c950e8872587fcdfc324d"
    sha256 cellar: :any,                 monterey:       "dc39d6bd74d4db919ee8bde5d9cbab396c43464bd8eb648d2ebc6d237edc77f6"
    sha256 cellar: :any,                 big_sur:        "22ebe049e3e896037414a0f994ec5a3c4be7266d5c8277c548992e8644d523c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7cc3a9aa2d9fb36734be81ad92983c9547332eb10780328051ad65abe9fa162"
  end

  depends_on "openssl@3"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sslscan --version")
    system "#{bin}/sslscan", "google.com"
  end
end
