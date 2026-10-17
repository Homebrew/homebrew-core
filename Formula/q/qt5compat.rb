class Qt5compat < Formula
  desc "Qt 5 Core APIs that were removed in Qt 6"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qt5compat-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qt5compat-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qt5compat-everywhere-src-6.12.0.tar.xz"
  sha256 "78cf1c283795312a7fa31c73eb7f7f556b48374adc484f10ad5a3c0bcb59264e"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-2-Clause", # src/core5/codecs
    "BSD-3-Clause", # *.cmake
  ]
  revision 1
  compatibility_version 1
  head "https://code.qt.io/qt/qt5compat.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c2cef4e1c4dfce293af55b4c49e8e7960f9a08bc884f94ade782baeb697fbcdd"
    sha256 cellar: :any, arm64_tahoe:       "df469b4f3bca9d05a183498087fb699a54ca9a974a46576774ca6bd28e54165f"
    sha256 cellar: :any, arm64_sequoia:     "4c8e2ef0c6d89ddc1712645df48853d16e7a21b6bd40630e6a154c162eb111e2"
    sha256 cellar: :any, arm64_linux:       "0d672511952d432923d8b2a8f90228a133a662f58832842e0bb442efa26f0e28"
    sha256 cellar: :any, x86_64_linux:      "dd80a023c11e9695424f84aa7a7fc8cc0d37c744e2bfb7d92758dd6c2bdae578"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "icu4c@79"
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtshadertools"

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS Core5Compat)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Core5Compat)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += core5compat
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QChar>
      #include <QString>
      #include <QStringRef>

      int main(void) {
        const QString hw = QStringLiteral("Hello World");
        const QStringRef ref = QStringRef(&hw).mid(6);
        Q_ASSERT(ref.at(0) == QChar('W'));
        Q_ASSERT(ref.at(4) == QChar('d'));
        return 0;
      }
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", "-S", ".", "-B", "cmake"
    system "cmake", "--build", "cmake"
    system "./cmake/test"

    ENV.delete "CPATH" if OS.mac?
    mkdir "qmake" do
      system formula_opt_bin("qtbase")/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6Core5Compat").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
