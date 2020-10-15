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
    sha256 "adc0501ff362f3f71de2074ff00e4160d2df6f1659028a3377c229572813f593" => :catalina
    sha256 "30875bd698e136fe81c9161ed5e5ee75817325828bf9c2766fc95e07caba4d73" => :mojave
    sha256 "71fc4b9ecbe7f67fca0a5d5ae231f5689bdfac4ac7d7ea45aefd6f8096026ebb" => :high_sierra
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
