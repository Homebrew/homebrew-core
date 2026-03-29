class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.14.5/qxmpp-v1.14.5.tar.bz2"
  sha256 "6197845135b2ad376c3c43fc211926cfec0f9bc9ffaffa81b296ce287a84ece5"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "df676d7359c12e05f2afbb9cb302a942026eacb9fc8c375e0dd1e250429217c5"
    sha256 cellar: :any,                 arm64_sequoia: "419522b7ff2a476e6fdb704043a7d057451119fa47fb2880f5cfee56a3e600cb"
    sha256 cellar: :any,                 arm64_sonoma:  "cd22ca94a22e5a8f32d423d5668c2ddb6e43ff4510c0eeb28620ebdb829327dc"
    sha256 cellar: :any,                 sonoma:        "d93edbec759eff8ff9cfb438cfb2a2a46bd1c53443817cf34b17aabfa84e56b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80e993dc19bd394e832b32191ef798c4e11eef9ba76c7f97662453923f0c935b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "419e5d1c8ef95b8d54aa7601bb0e7737b999db0f5a10c8c30c30e2e94f4c038e"
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
