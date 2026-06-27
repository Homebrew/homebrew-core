class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.16.1/qxmpp-v1.16.1.tar.bz2"
  sha256 "4fc5a0b168481b1ff93add1d7f391c72d8f1932d380d55230e9bb3673f3cdee2"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "235d6cb105c80832414666eaf3c903621d43ca6161b973ebdca6762cf8b5bd44"
    sha256 cellar: :any, arm64_sequoia: "f6538b21be265db24bd834f5fbd3a836f6fa2d4260f35a167efb14ec40a130d9"
    sha256 cellar: :any, arm64_sonoma:  "b065cf5622882b7346f693cf8a478c4edeb5eb6f5ad1f0b170ffad2e3157398d"
    sha256 cellar: :any, sonoma:        "b36a999a4bdf583412434350eafc9de977ad698f5a4ed2fbfabd1f1db858b746"
    sha256 cellar: :any, arm64_linux:   "a375c052c55a1f9fabedcdedec13a3097e5fedf89ef3724e391adbe4f676f3ec"
    sha256 cellar: :any, x86_64_linux:  "290601bf14b91872132b285a5bdbb0eda831850cfa051e0c92ad53274f22ed54"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build
  depends_on "openssl@3"
  depends_on "qtbase"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "llvm" => :build if DevelopmentTools.gcc_version < 14
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "13"
    cause "Requires C++20 and GCC 13 crashes with ICE"
  end

  def install
    ENV.llvm_clang if OS.linux? && deps.map(&:name).any?("llvm")

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_DOCUMENTATION=OFF", *std_cmake_args
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
