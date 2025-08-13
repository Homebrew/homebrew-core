class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.11.1/qxmpp-v1.11.1.tar.bz2"
  sha256 "a427dafd23ce3b4c5447886558fdaebfbc4fb70974bdf82984b75ad59674126b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "927f6f32f2f6748c6db4bdcf726f503e4be2626a772babf37d2e8be17fc9fc64"
    sha256 cellar: :any,                 arm64_ventura: "599abd8cea19f8951f3518bb649fbdd1cf7f35a3c85e414231a85aed0438060e"
    sha256 cellar: :any,                 sonoma:        "2b4215786c74e012e8e6a22eda45ddb14e22493a260c57da48d2ff88c955ce7d"
    sha256 cellar: :any,                 ventura:       "da033a9b7a6211fe8b598863765ca3feadf6deb390939e6fcb29f5e19817db4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31c2d1dbdec20af0800b293d32e01a8b009961a69d61538e3f6eea021269d187"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build
  depends_on "qt"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    rpath_dirs = [lib]
    # FIXME: This links with GCC's libstdc++ (as a recursive dependency)
    dot_pro_preamble = if OS.linux?
      gcc = Formula["gcc"]
      rpath_dirs << (gcc.opt_lib/"gcc/current") if OS.linux?

      qmake_cc = gcc.opt_bin/"gcc-#{gcc.version.major}"
      qmake_cxx = gcc.opt_bin/"g++-#{gcc.version.major}"

      ENV["CC"] = qmake_cc
      ENV["CXX"] = qmake_cxx

      <<~EOS
        QMAKE_CC =  #{qmake_cc}
        QMAKE_CXX = #{qmake_cxx}
      EOS
    end

    ENV.delete "CPATH"
    (testpath/"test.pro").write <<~EOS
      #{dot_pro_preamble}
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      QT          += network
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lQXmppQt6
      QMAKE_RPATHDIR += #{rpath_dirs.join(" ")}
    EOS

    (testpath/"test.cpp").write <<~CPP
      #include <QXmppQt6/QXmppClient.h>
      int main() {
        QXmppClient client;
        return 0;
      }
    CPP

    system "#{Formula["qt"].bin}/qmake", "test.pro"
    system "make"
    assert_path_exists testpath/"test", "test output file does not exist!"
    system "./test"
  end
end
