class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.0.tar.gz"
  sha256 "f582c4b1c9ff6cadde4a3130a3f721866faf6048f5b1cddd1f696dc5a6fb7921"
  license "GPL-3.0"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "788f9752e795f4ff95e1251a243a5829a6f9b40facbdca40e4819de5f9d7dc4c" => :catalina
    sha256 "8a8826da03dbbaa9ee89c8e6b95496c178f5a93d86468402fb6e432ebc7f2c68" => :mojave
    sha256 "e0735e75b58b7cb0ef72cc79089df545e0140e52bc206c1791ab979192251d22" => :high_sierra
    sha256 "4b00ee57ccf8dfbc890bbc7ca978dd4f310e7f73dfc022c78c33b69b9b3449dc" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    # use `libcrypto.dylib` built from `openssl@1.1`
    inreplace "Makefile", "static: openssl/libcrypto.a",
                          "static: #{Formula["openssl@1.1"].opt_lib}/libcrypto.dylib"

    system "make", "static"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "static", shell_output("#{bin}/sslscan --version")
    system "#{bin}/sslscan", "google.com"
  end
end
