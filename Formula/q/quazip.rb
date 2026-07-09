class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "5240f4a3475648773ba10af8b0ebe549cbfc5d6de00470a517330a80068a4f78"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "949ca6bbf73c080cbaced4a9611eb02b94876055ed843a2dc1b0fa12463d9ef8"
    sha256 cellar: :any, arm64_sequoia: "b7c21a9875e6cba5caf39d35749de86f8ce77e35b780e4634f08911299a046e2"
    sha256 cellar: :any, arm64_sonoma:  "c1052ef03a5ea6e99f1aea0ddbe60257ee51e588f8a1b08be74cf352e42a6c1a"
    sha256 cellar: :any, sonoma:        "5b3d73973a0b00325fba4110ecc35a66c771cbe3444385b71d3e14f4e85286dc"
    sha256 cellar: :any, arm64_linux:   "d65b50c2f074355df91b0e8ed9602d614c154aa8b71bf61ccdd4dc0e091999f7"
    sha256 cellar: :any, x86_64_linux:  "8b5c387b4c62463a67c23f4ebf8959aff6d4b89f459489f69419bd64bb8d6b86"
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
