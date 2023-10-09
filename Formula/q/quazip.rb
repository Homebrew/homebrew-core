class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/v1.4.tar.gz"
  sha256 "79633fd3a18e2d11a7d5c40c4c79c1786ba0c74b59ad752e8429746fe1781dd6"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b917ed1fd711fd8abaf77825f077340bfdea202ea1ee96e3fdb4b073d62b2db2"
    sha256 cellar: :any,                 arm64_ventura:  "29ad7c05c766208ae51d0c220e83a98313ebd55e804cac3a627e9097591bbbb6"
    sha256 cellar: :any,                 arm64_monterey: "86c13aac1ac1d25a71d4a293c1b5c4cc683cc900c12d3a0bb40f64f5e5867a5f"
    sha256 cellar: :any,                 arm64_big_sur:  "247b7788823f0b63f6e07644478a39c44d282fd7ec1d87302549c1905bef8898"
    sha256 cellar: :any,                 sonoma:         "04cf70a2114e204931e750b79e6573fb6d8914a2c0893fe1412e413e5e5c0b67"
    sha256 cellar: :any,                 ventura:        "787aa2aad4f009e230c77c92d73c40851f82bd8711e02da3f490426adea5c5d2"
    sha256 cellar: :any,                 monterey:       "1ba3e44696f2612a297050db3502f0087cc41eedb4e07be65ee13af72e182a16"
    sha256 cellar: :any,                 big_sur:        "dbc4fd05eb139a16baa6d0a1c8f3dba25d63f6272b0c2cc0e4d3b5f363911eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0523a1e075f87a641161a89a6b936e975923fc2e29afa9b61e40562be74f639"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt"

  fails_with gcc: "5" # C++17

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
      INCLUDEPATH    += #{include}
      LIBPATH        += #{lib}
      LIBS           += -lquazip#{version.major}-qt#{Formula["qt"].version.major}
      QMAKE_RPATHDIR += #{lib}
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <quazip/quazip.h>
      int main() {
        QuaZip zip;
        return 0;
      }
    EOS

    system Formula["qt"].bin/"qmake", "test.pro"
    system "make"
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
