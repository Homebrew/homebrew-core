class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/v1.3.tar.gz"
  sha256 "c1239559cd6860cab80a0fd81f4204e606f9324f702dab6166b0960676ee1754"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1a90afdde6493e15734bea6d7a28ae564587f34aeb92869a64e144caa6fe9ee8"
    sha256 cellar: :any,                 arm64_big_sur:  "2f880c097eca45aada016573e392d2f7138813b4583dce0cf7d78a64a5e57709"
    sha256 cellar: :any,                 monterey:       "d5d59babd543adc6c638229cd727bad679543a1aac2e944c72f7c8c3a3093b6e"
    sha256 cellar: :any,                 big_sur:        "d3c54b37b3a5666873ef96f5e58fbdddd221c096cdb502b98938a94af43b9627"
    sha256 cellar: :any,                 catalina:       "803e17b2e45326eb8a4e534f20fddfa138fe0d3f570798ce48a8135af9604ef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4d08d29dabd478538204972235ecbc739f1a3bf84ee9878c6ec67a2f93b465b"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # C++17

  def install
    system "cmake", ".", "-DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_lib}", *std_cmake_args
    system "make"
    system "make", "install"

    cd include do
      include.install_symlink "QuaZip-Qt#{Formula["qt"].version.major}-#{version}/quazip" => "quazip"
    end
  end

  test do
    ENV.delete "CPATH"
    (testpath/"test.pro").write <<~EOS
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lquazip#{version.major}-qt#{Formula["qt"].version.major}
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <quazip/quazip.h>
      int main() {
        QuaZip zip;
        return 0;
      }
    EOS

    system "#{Formula["qt"].bin}/qmake", "test.pro"
    system "make"
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
