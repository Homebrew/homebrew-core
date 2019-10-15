class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/v2.1.1.tar.gz"
  sha256 "29627520c81101de01b0213434adb218a9f1210bfd3f2dcfdfc1f975dbce6399"
  revision 1
  head "https://github.com/zmap/zmap.git"

  bottle do
    rebuild 1
    sha256 "c2665c378d96627ada38979ecf38e8dfd4729083b805005c8784e97033b58f36" => :catalina
    sha256 "af12dfa471443be095ccbbb1d0fb8f706e966786d8526b2190f2cfe78f28550c" => :mojave
    sha256 "d64ac689f0e80bc125a5e4899cc044395b0ba5c75ad365f65a3f6f8a62520137" => :high_sierra
    sha256 "233f9e5e6964477295c0e9edbf607cd71571155510704124f374934f97eff55c" => :sierra
  end

  depends_on "byacc" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "json-c"
  depends_on "libdnet"

  def install
    inreplace ["conf/zmap.conf", "src/zmap.c", "src/zopt.ggo.in"], "/etc", etc

    system "cmake", ".", *std_cmake_args, "-DENABLE_DEVELOPMENT=OFF",
                         "-DRESPECT_INSTALL_PREFIX_CONFIG=ON"
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/zmap", "--version"
  end
end
