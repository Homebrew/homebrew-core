class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/refs/tags/v1.5.tar.gz"
  sha256 "405b72b6e76c8987ff41a762523b8f64876ba406d8a831d268ee0b63f1369582"
  license "LGPL-2.1-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f1fd2fadf19095977d5632337b0bbe73cefa515ef6b17c3d9de2fea32bfd1b24"
    sha256 cellar: :any,                 arm64_sequoia: "185ebc43b7a1136a46c8af18b442f2f2f8b7196422072a1a6835bbd0a30875a2"
    sha256 cellar: :any,                 arm64_sonoma:  "535fb4aab113e08ae887ee225e49583f347cd727a918a46b91c84b04c5c2c465"
    sha256 cellar: :any,                 sonoma:        "ee6d72c263395d2bd8cb95341cca19f620b851196cbfdabfd0192f51d75748cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d457d617c5a876a3ad949e196936bbdf1d26cc9d34319418a53bfd9c0df1234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ae3f76ea4c6aed76a42025c5475c4b1a030cccd04ea102a54b98efc7d1a3f57"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt5compat"
  depends_on "qtbase"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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

    system Formula["qtbase"].bin/"qmake", "test.pro"
    system "make"
    assert_path_exists testpath/"test", "test output file does not exist!"
    system "./test"
  end
end
