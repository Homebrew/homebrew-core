class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.0.tar.gz"
  sha256 "f582c4b1c9ff6cadde4a3130a3f721866faf6048f5b1cddd1f696dc5a6fb7921"
  license "GPL-3.0"
  head "https://github.com/rbsec/sslscan.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:-rbsec)?$/i)
  end

  bottle do
    cellar :any
    sha256 "0949543e58e7665068a56a31d977de39d2c092489a05766321ac8297296f79d9" => :catalina
    sha256 "27b2d69702049d3663743745e5415196512c54c4a736a79d192c721cfa27597b" => :mojave
    sha256 "369d750ed9b291f096efb2166475e5daeb0c0b0c4d9f438746b861a6c40de799" => :high_sierra
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
