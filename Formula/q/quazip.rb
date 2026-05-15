class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/refs/tags/v1.5.tar.gz"
  sha256 "405b72b6e76c8987ff41a762523b8f64876ba406d8a831d268ee0b63f1369582"
  license "LGPL-2.1-only"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "ce8d0c6f5b6d725631a9023470fd138c99d9db401f03902f828f555140fee77b"
    sha256 cellar: :any,                 arm64_sequoia: "7272d9b6eec18911f7fef8cd0c5deb264b655463396bb220220974d32a3227dc"
    sha256 cellar: :any,                 arm64_sonoma:  "445a4429e3a6a27ffb00565a01b994b45b8af48c6b9aa8bcba68263a3e81ec87"
    sha256 cellar: :any,                 sonoma:        "1252f9215183b55908a1df0caf982f7dd7f209289d461a9eb3c5cd7e3146796f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7faf8e516ab4ecff091c0fe8bdc1d0d1ecdcf12ac06562fd7aa96626e58363b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "834a87bcf3b62f24ea5446e5ab3400ac499042d56a1c0065a0eb3cfea929e9a4"
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
