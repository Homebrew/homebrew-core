class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/v2.1.1.tar.gz"
  sha256 "29627520c81101de01b0213434adb218a9f1210bfd3f2dcfdfc1f975dbce6399"
  revision 1
  head "https://github.com/zmap/zmap.git"

  bottle do
    sha256 "47d8698c87325c5b3c546d42da897fb093b58e5cc872f47bb968008e05da9d70" => :mojave
    sha256 "5bf98e6e2fea460c2b456f7017aff0064590994b47058ae5296738445cc37999" => :high_sierra
    sha256 "0f02a61d2563ec4359b90eaa3d637d53e2a5aa8bbbfbc78a8ba76780e3f565d1" => :sierra
    sha256 "517ccb75b370f3deee62725a9e74b53a7d3949f3ef214a8769983c7eab72f83e" => :el_capitan
  end

  deprecated_option "with-mongo-c" => "with-mongo-c-driver"

  depends_on "byacc" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "json-c"
  depends_on "libdnet"
  depends_on "hiredis" => :optional
  depends_on "mongo-c-driver" => :optional

  def install
    inreplace ["conf/zmap.conf", "src/zmap.c", "src/zopt.ggo.in"], "/etc", etc

    args = std_cmake_args
    args << "-DENABLE_DEVELOPMENT=OFF"
    args << "-DRESPECT_INSTALL_PREFIX_CONFIG=ON"
    args << "-DWITH_REDIS=ON" if build.with? "hiredis"
    args << "-DWITH_MONGO=ON" if build.with? "mongo-c-driver"

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/zmap", "--version"
    assert_match /redis-csv/, `#{sbin}/zmap --list-output-modules` if build.with? "hiredis"
    assert_match /mongo/, `#{sbin}/zmap --list-output-modules` if build.with? "mongo-c-driver"
  end
end
