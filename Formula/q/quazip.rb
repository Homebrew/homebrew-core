class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/refs/tags/v1.5.tar.gz"
  sha256 "405b72b6e76c8987ff41a762523b8f64876ba406d8a831d268ee0b63f1369582"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "568975c79a7542774eba015531d200fba3ab5bea77c1c6497761d8168e09d2ad"
    sha256 cellar: :any,                 arm64_ventura: "6ae800f41e9dd803ededcee7f81736cde1fe9aaabb52ffafd8423620dd8dd701"
    sha256 cellar: :any,                 sonoma:        "2f12beb8f666e4e9d885a0c155e1cbab98fe2a7ee17130244e527d11f0a2a7fd"
    sha256 cellar: :any,                 ventura:       "e4144bd17991b751d5d43307b07a480b9ba216c0882f555b8c40933a903ac29e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f5ee3084b058aad33e77d0f7e8d07af219f5ada4e3db0f7897d00660de19825"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_lib}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cd include do
      include.install_symlink "QuaZip-Qt#{Formula["qt"].version.major}-#{version}/quazip" => "quazip"
    end
  end

  test do
    ENV.delete "CPATH"
    (testpath/"test.pro").write <<~EOS
      TEMPLATE        = app
      CONFIG         += console
      CONFIG         -= app_bundle
      TARGET          = test
      SOURCES        += test.cpp
      INCLUDEPATH    += #{include} #{Formula["zlib"].include}
      LIBPATH        += #{lib}
      LIBS           += -lquazip#{version.major}-qt#{Formula["qt"].version.major}
      QMAKE_RPATHDIR += #{lib}
    EOS

    (testpath/"test.cpp").write <<~CPP
      #include <quazip/quazip.h>
      int main() {
        QuaZip zip;
        return 0;
      }
    CPP

    system Formula["qt"].bin/"qmake", "test.pro"
    system "make"
    assert_path_exists testpath/"test", "test output file does not exist!"
    system "./test"
  end
end
