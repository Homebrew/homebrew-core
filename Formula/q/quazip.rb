class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "e3c7220e66d9f8024ef4aa98befb2592fea219a01736a400b07b11aa60964d02"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a25530d908b8f40c31f4ea13441416792461b3f0b531a9c542f6a060b6afd491"
    sha256 cellar: :any, arm64_sequoia: "6230ccbb7e433abd3c40669bc233a236302d2618d0e2c6ea5132d2e2ba016fee"
    sha256 cellar: :any, arm64_sonoma:  "51f5ec3249d0e161c4aada50393070db8c5271e1c1def4f014ef4e5b4fcda10f"
    sha256 cellar: :any, sonoma:        "aefc424f9c20cd9f511109500e902716033e1786139d425cca13e28cd2e0e405"
    sha256 cellar: :any, arm64_linux:   "c10e0469fbded61aa17196a82c7af6f96c0466931af9346f63c9ba15e8b79efb"
    sha256 cellar: :any, x86_64_linux:  "93be15ad51f982d25bb8f2accba397f8400a16bbd65ede23234d57ef9b49e096"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt5compat"
  depends_on "qtbase"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cd include do
      include.install_symlink "QuaZip-Qt#{Formula["qtbase"].version.major}-#{version}/quazip" => "quazip"
    end
  end

  test do
    ENV.delete "CPATH"
    (testpath/"test.pro").write <<~EOS
      QT             += core5compat
      TEMPLATE        = app
      CONFIG         += console
      CONFIG         -= app_bundle
      TARGET          = test
      SOURCES        += test.cpp
      INCLUDEPATH    += #{include} #{Formula["zlib-ng-compat"].include}
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

    system Formula["qtbase"].bin/"qmake", "test.pro"
    system "make"
    assert_path_exists testpath/"test", "test output file does not exist!"
    system "./test"
  end
end
