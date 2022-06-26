class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.14.tar.gz"
  sha256 "0dd9f7d0f08c777dfebb1fd10ba369d3a2fd9b978f262384d30e1f45845a67ba"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3c38d56228c2d9b425c606eec4c45f4567bdb104abe958f43d82740a742b8554"
    sha256 cellar: :any,                 arm64_big_sur:  "80dd275ef4c6be098e541fed92fd911ed2f9d52f7af80c1a6076ee9fbe14f617"
    sha256 cellar: :any,                 monterey:       "99251d0a07be9280d1ccadd93564e08251edc1fec581823c45bd06bfe0e60ee9"
    sha256 cellar: :any,                 big_sur:        "ba7a22878d35766987aab858f77db51eca604b54241941b9f93ad84f2938085d"
    sha256 cellar: :any,                 catalina:       "35bb85347c22077b6247c7cff3bd0d046a2ecefc4a41bd2e5832197efa3455f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92b84f8ddb0e2fb3fe9de61878f027297b3e0b2d7a14ce9772bd53c1b06bf6df"
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
