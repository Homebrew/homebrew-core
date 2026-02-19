class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.14.1/qxmpp-v1.14.1.tar.bz2"
  sha256 "a72e5c42f67daef0063a5f54a3caf030cd740c8d7982ea85f9f69dbb45e78d96"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "983493a1193e86efd275461d2fece428095741c20bb989ea15b266ba65a37828"
    sha256 cellar: :any,                 arm64_sequoia: "05d635b41a24bd99e6ec1c1546f0e668544f3b5150abc25c9780089fdf1eeb95"
    sha256 cellar: :any,                 arm64_sonoma:  "f96cbd0f0a087b53db98ef13baa061504499160fb726dd0be117ed51f84ca8f2"
    sha256 cellar: :any,                 sonoma:        "fb2e283bd589ba3b8f151a669867cd34d21d1ade133144c6ef7adb289d9603fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a280227317f2bcfef5453c9f2cf2c4da5c3143dbcc15b12892f014e0d028b920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df1a1012e098f146a23785e5a93054e01e6609dd43cf0130ebda55cfe40f083f"
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
