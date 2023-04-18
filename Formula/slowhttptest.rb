class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://github.com/shekyan/slowhttptest/archive/v1.9.0.tar.gz"
  sha256 "a3910b9b844e05ee55838aa17beddc6aa9d6c5c0012eab647a21cc9ccd6c8749"
  license "Apache-2.0"
  head "https://github.com/shekyan/slowhttptest.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "68f9552d0393f75f8530f7e2100e7325178dff70197e0db2df7037f4396bc55f"
    sha256 cellar: :any,                 arm64_monterey: "f44686a2cd459960a69bba155aadf7d83e1bd550d894b349dc6f457a7232c13d"
    sha256 cellar: :any,                 arm64_big_sur:  "d7ac9431e1ae5708175dcd3f8cfbb96189a78621eed8ac99bd06b9b8b6ba22b7"
    sha256 cellar: :any,                 ventura:        "a4a82aed233b8a3e14f2e6870a5460edd7f5645f6b8c60033355b1ef6fe4e800"
    sha256 cellar: :any,                 monterey:       "85676dfbf81eddac78cb31816f86f8667e6726398ef68be3d2b490f3e78028bc"
    sha256 cellar: :any,                 big_sur:        "1818300aa4c7c76e0eb05f100009faf97a07fe43133a7f66e09abefb61a5c229"
    sha256 cellar: :any,                 catalina:       "bce898dc331e6dbbd7af3c39c8b385eb6deb67eedb1e0ca7344d2a45f7f98442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3c40357c9bd384b991dc20163d7a1575f2ab2df0f53dfde971a044fd2304e50"
  end

  depends_on "openssl@3"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/slowhttptest", "-u", "https://google.com",
                                  "-p", "1", "-r", "1", "-l", "1", "-i", "1"

    assert_match version.to_s, shell_output("#{bin}/slowhttptest -h", 1)
  end
end
