class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.14.3/qxmpp-v1.14.3.tar.bz2"
  sha256 "827988d60ff601735879b8bf02cfbd26b185e196191b0e366a46b21be3a0f74d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "829287475fef2861a8de57d12eb5c5ba2dac5bf1393411ebbe7941a5b9893324"
    sha256 cellar: :any,                 arm64_sequoia: "076be3b3ebef09527ea61b4c897c4d3a51422ddaf0b366569b43a56f17f7f4c9"
    sha256 cellar: :any,                 arm64_sonoma:  "06bdbd998574c532afaa76951a414e9ee8d9dbee94e75a90f40be73f11a7607e"
    sha256 cellar: :any,                 sonoma:        "a259dfae356d1425b61b6a9a5feda2e45a857a4f903c13276ebe741afb328c30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64dcfe7f1633a2302fed2e16099501e08c50a1a7b5257c24ce179145dc5604b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a02d91a8a28aa70ef456402074a34389801f62106c7b6c8354a3bdb54500da80"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build
  depends_on "qtbase"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "llvm" => :build if DevelopmentTools.gcc_version < 13
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.linux? && deps.map(&:name).any?("llvm")

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV.delete "CPATH"
    (testpath/"test.pro").write <<~QMAKE
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      QT          += network
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lQXmppQt6
      QMAKE_RPATHDIR += #{lib}
    QMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <QXmppQt6/QXmppClient.h>
      int main() {
        QXmppClient client;
        return 0;
      }
    CPP

    system Formula["qtbase"].bin/"qmake", "test.pro"
    system "make"
    assert_path_exists testpath/"test", "test output file does not exist!"
    system "./test"
  end
end
