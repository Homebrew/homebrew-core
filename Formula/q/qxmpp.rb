class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://invent.kde.org/libraries/qxmpp"
  url "https://invent.kde.org/libraries/qxmpp/-/archive/v1.14.0/qxmpp-v1.14.0.tar.bz2"
  sha256 "85ee1523f832434aa71f5375632c49db781880322d374cd75f58e7be44065ed4"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1e25dec01b027af16be7957e23907e68181e0d6e34ecea584f48592d6bf9be38"
    sha256 cellar: :any,                 arm64_sequoia: "3130434ce6b94b29ce6fd3f8e8900d54e123adaafdce9f384ec338976339dfe9"
    sha256 cellar: :any,                 arm64_sonoma:  "c47299553eb92b206200e354cf3081793efa37f25578c7e5e7b98f0d08b39758"
    sha256 cellar: :any,                 sonoma:        "9f47be56bc9f83fd469989798b20cb8d6a0573bc57d3bbee20f8e3bc7e558f59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c8720b944af9a956f9ccdd5f5e3ce14bc1c8b4fd4c5d3aa8db526ed710266ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8341173efc53537a2e47b5e89e9701dcf1d75550037ce71187ce770ad8c96117"
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
