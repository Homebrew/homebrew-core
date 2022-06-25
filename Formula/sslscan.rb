class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.14.tar.gz"
  sha256 "0dd9f7d0f08c777dfebb1fd10ba369d3a2fd9b978f262384d30e1f45845a67ba"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "836951f43d6608b813d7bc1c6ef6de2a6533a5cb9b9935358d0c57d6ffc7f302"
    sha256 cellar: :any,                 arm64_big_sur:  "96ad7d01e342880dd402746d097e9717688f3d1cfb92d62db9d3c912277d5dc4"
    sha256 cellar: :any,                 monterey:       "dbe8db7512295737f7b425df3d722774a64e3e3df0b8fc41e6217a29c6d26703"
    sha256 cellar: :any,                 big_sur:        "4716a56b36bf8b640213057818393bd043104043075f0076cd8484f46bba9b6d"
    sha256 cellar: :any,                 catalina:       "7206ababb391c78d0fea16bc4d256dd1ad2ecf46dbd2ffbcc19239751babde79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a14c08ecd33e99e69ab5ba041ed5440ce75c4f72fa2e9438acd2921ef47f582"
  end

  depends_on "openssl@1.1"

  def install
    # use `libcrypto.dylib|so` built from `openssl@1.1`
    inreplace "Makefile", "./openssl/libssl.a",
                          "#{Formula["openssl@1.1"].opt_lib}/#{shared_library("libssl")}"
    inreplace "Makefile", "./openssl/libcrypto.a",
                          "#{Formula["openssl@1.1"].opt_lib}/#{shared_library("libcrypto")}"
    inreplace "Makefile", "static: openssl/libcrypto.a",
                          "static: #{Formula["openssl@1.1"].opt_lib}/#{shared_library("libcrypto")}"

    system "make", "static"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "static", shell_output("#{bin}/sslscan --version")
    system "#{bin}/sslscan", "google.com"
  end
end
