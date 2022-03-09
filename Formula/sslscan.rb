class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.12.tar.gz"
  sha256 "6eeda19f564635818d6dd20a1e93174484d62acb24eca8944df07496d32b9c65"
  license "GPL-3.0-or-later"
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f677c1e116c5495901b81a4b00a313508ef40878e3c3973c2e4eeb7353a5e76b"
    sha256 cellar: :any,                 arm64_big_sur:  "464bab8562a9459731c06c39f00020f1bc5f63a099aece08ae574adf79945e2f"
    sha256 cellar: :any,                 monterey:       "7921cd2103a9d6b7145b87d852dd4f229ff8ec49ec451dfad0573615a8127609"
    sha256 cellar: :any,                 big_sur:        "c183f60f3ed7073dadccd20e691c6d87e33a5e573694485d58bc52a9b2b5c61d"
    sha256 cellar: :any,                 catalina:       "f5ef2ab35fd23934b0068b3f5a00916c95466de2a9bfc25fca1d8c417133461d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0457169f9981b0612ee9e6210c6f8633d7072892db61c29caeed332d602ff70c"
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
