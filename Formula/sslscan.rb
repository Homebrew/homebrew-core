class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.8.tar.gz"
  sha256 "c21f12082bf554908d824fcd2ce342dff1a1dbcab98efa9ea033f5ebdec7974e"
  license "GPL-3.0-or-later"
  head "https://github.com/rbsec/sslscan.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:-rbsec)?$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ddb78bfa279f0dd7a40a7cf42663f315cd4fe02451a573c10db683c7c992c8ce"
    sha256 cellar: :any, big_sur:       "c4d36dd15745281e258416b21eb884891f045a0d822d9d6391ddc1ed1a83e429"
    sha256 cellar: :any, catalina:      "3fc799c6195682f4002ac57c0ccb0c69cee753227d5aa898f522d868d9a46673"
    sha256 cellar: :any, mojave:        "5ebaa3049ff956d91d8aebb542c6b0b4759b268c5f4a67347d2b88a8f2af86fd"
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
