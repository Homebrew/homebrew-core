class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.10.tar.gz"
  sha256 "bb7bb0ff037aa5579b3ee0cf91aa41ab04ac073592b5d95ad3fab820f5000f6e"
  license "GPL-3.0-or-later"
  head "https://github.com/rbsec/sslscan.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:-rbsec)?$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8a3fdc786fb3b6990873bc8b060d8fbe72b94e902c7d147ddab5578952d904ba"
    sha256 cellar: :any, big_sur:       "b2dbd6726386de8f4ed98717bb891117eacd4e3fc86b72556500e4da0802c694"
    sha256 cellar: :any, catalina:      "3a2ee1806e85d481f046ce00e359a863cb8a8cb2e73f39c3d124f2a08c8daaf3"
    sha256 cellar: :any, mojave:        "482290749bffb04bfe09c48a5f4ba879b02a9efd7a98ccf1c3102e235838638c"
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
