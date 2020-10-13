class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.4.tar.gz"
  sha256 "245252982076103f1c20e9f136e38070c0b71fbcd98a3a04aa0175bef5acc8b9"
  license "GPL-3.0-or-later"
  head "https://github.com/rbsec/sslscan.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:-rbsec)?$/i)
  end

  bottle do
    cellar :any
    sha256 "98092566e87639eb3a52b036b2af36e44cba0ee567f66602ab35ca8c108d7cde" => :catalina
    sha256 "68fa1a1553cdcdf604504728d8405861753fcf8d88f17f43bf8445bacdd1352f" => :mojave
    sha256 "49fa7b58ca4c2703a490d43dde97d54ac5264597ed3c4445fd947bf850e2d5d9" => :high_sierra
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
