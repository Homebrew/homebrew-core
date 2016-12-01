class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/v2.1.1.tar.gz"
  sha256 "29627520c81101de01b0213434adb218a9f1210bfd3f2dcfdfc1f975dbce6399"

  head "https://github.com/zmap/zmap.git"

  bottle do
    rebuild 1
    sha256 "659f3518abb4023324778a16fa306abc8d8c43b34c9bd16e6bc7e412f1a511d6" => :sierra
    sha256 "d8c0781ebec0087401d6fe6c272b0ae83620590db314fc6cea5c5d33aea46725" => :el_capitan
    sha256 "15c8181a1e086b39d88223f3a01bb29d868d9d7d6c3118973250833da96f38cb" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "byacc" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "libdnet"
  depends_on "json-c"
  depends_on "hiredis" => :optional
  depends_on "mongo-c-driver" => :optional

  deprecated_option "with-mongo-c" => "with-mongo-c-driver"

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
