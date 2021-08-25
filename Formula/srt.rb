class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.4.3.tar.gz"
  sha256 "c06e05664c71d635c37207a2b5a444f2c4a95950a3548402b3e0c524f735b33d"
  license "MPL-2.0"
  head "https://github.com/Haivision/srt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "5030a6897c290fe9c26bcd06b1033ca4e11b25709057f39060b2f3ad37235bf5"
    sha256 cellar: :any,                 big_sur:       "5f8231fcfa94e640638c5a6b38e75630d48338118a578308dea0fa7e0deaadfd"
    sha256 cellar: :any,                 catalina:      "1f1cdf82af07c72eeeee3a1ea96f87123f45fff74f6f4615fd491fe15e77f37b"
    sha256 cellar: :any,                 mojave:        "37b8bb756634847c6ea8f53a32a61c3228f960e168953f0da646ae462396ca12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0846df9e0c758dab3fe24f5b79c25e405771bb289ec9a90be037aa37f728ad63"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    openssl = Formula["openssl@1.1"]
    system "cmake", ".", "-DWITH_OPENSSL_INCLUDEDIR=#{openssl.opt_include}",
                         "-DWITH_OPENSSL_LIBDIR=#{openssl.opt_lib}",
                         "-DCMAKE_INSTALL_BINDIR=bin",
                         "-DCMAKE_INSTALL_LIBDIR=lib",
                         "-DCMAKE_INSTALL_INCLUDEDIR=include",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    cmd = "#{bin}/srt-live-transmit file:///dev/null file://con/ 2>&1"
    assert_match "Unsupported source type", shell_output(cmd, 1)
  end
end
