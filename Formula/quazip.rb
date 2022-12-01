class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/v1.3.tar.gz"
  sha256 "c1239559cd6860cab80a0fd81f4204e606f9324f702dab6166b0960676ee1754"
  license "LGPL-2.1-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "3809e4b7c831115e815f3fa7b84b9e537549a82a7e089a4007b0f752fd071c75"
    sha256 cellar: :any,                 arm64_monterey: "46931218c7df1222282017d17ebaa4c22a05c6da6a62f605844b739c35bbef7a"
    sha256 cellar: :any,                 arm64_big_sur:  "0e8abd2e6d2d81eb99ce309100c0e4115e364bd01344009cea7eef0d643096ee"
    sha256 cellar: :any,                 ventura:        "dd342e62e1a4e8402742864c7a3ed75954d719d2ac1c92ec09c4132e4d5bd1a8"
    sha256 cellar: :any,                 monterey:       "81eceb5944761190fab7e3fa3ebf64be503e13858a1a5ded1130d86172b02a71"
    sha256 cellar: :any,                 big_sur:        "753fd853f5823615f13e811e7813e5c95b1521d171bb2b612dd10a8e77bf4921"
    sha256 cellar: :any,                 catalina:       "59181f16535ae197a7e4863961c6286995d40640cd9659adbe57f40b1f917e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48d4f4e9e526b91297d4e768201a1d718500da5a2b61a2508308f2d54e96dbe6"
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
