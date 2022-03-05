class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.12.tar.gz"
  sha256 "6eeda19f564635818d6dd20a1e93174484d62acb24eca8944df07496d32b9c65"
  license "GPL-3.0-or-later"
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2ecbb60436191aad650902454485db6acc05491beee19e662774230c9c37095d"
    sha256 cellar: :any,                 arm64_big_sur:  "31bff322be81a06bda1274655c6eb391f345cb2ac7af9b0a2a8af8d123524cfe"
    sha256 cellar: :any,                 monterey:       "d7c2bf23ced03d7b5030dc8abb271aba5488f921146192e9a101a75c16bba94c"
    sha256 cellar: :any,                 big_sur:        "01fb6a36a458d700191261620813796c67da729c7b02f96573a5fc3de8a61ac9"
    sha256 cellar: :any,                 catalina:       "e71b9ce743ab9cce21ebaad1e2bf3f494273f87dd2f2261d963f7cf9a2912fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6121ef0e9a9fa6d5c854ffed359d87bc12dbf7af05cee72489d5c9acd93e4a78"
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
