class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.5.2.tar.gz"
  sha256 "463970a3f575446b3f55abb6f323d5476c963c77b3c975cd902e9c87cdd9a92c"
  license "MPL-2.0"
  head "https://github.com/Haivision/srt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cd2e45f7be1158e4f9480bea9f425d1ce269457c2f6a2f18c3119c2c72b3af50"
    sha256 cellar: :any,                 arm64_monterey: "2bd6dc0760694c380b66b4a17347075c420ba4a37d6f2475810c675ddd56208d"
    sha256 cellar: :any,                 arm64_big_sur:  "066aea3c2f61de131cbe57665022da530ee9cfd58616f8edc2ad75136c249e9d"
    sha256 cellar: :any,                 ventura:        "7072e6258e20ec27495062f8d78298e8d113f5f0ff559893075ad5192841f32a"
    sha256 cellar: :any,                 monterey:       "83f683b9c11af2daa82111ca680c923e619f04b8f834a737ddfeccd1fd866e5b"
    sha256 cellar: :any,                 big_sur:        "8a902633ce1c2ceb558ebdb06d49ef4c8da7eb2836b6a801a62c6658be5441ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9071902464e529bf91432967b71b5c83fec628714726856e447ddf7c0d2b663d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    openssl = Formula["openssl@3"]
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
