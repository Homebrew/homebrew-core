class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.5.tar.gz"
  sha256 "34a557a7996bb5c2f69fe512b7ef14ba272094178e76140535e50691bf934f99"
  license "GPL-3.0-or-later"
  head "https://github.com/rbsec/sslscan.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:-rbsec)?$/i)
  end

  bottle do
    cellar :any
    sha256 "0702cc8487b0084732d86d07bcc822d83a967567bb0248c7ff42862d779ff7c0" => :catalina
    sha256 "30b5a6fa056180ab04cdfa6d601a5b4d1cd553c407ae5e506602bee0e3542410" => :mojave
    sha256 "c9c9678f7980dc52992212800e0b7f8bbcd155988c163489eed938d3d58fa0a8" => :high_sierra
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
