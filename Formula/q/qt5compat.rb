class Qt5compat < Formula
  desc "Qt 5 Core APIs that were removed in Qt 6"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.0/submodules/qt5compat-everywhere-src-6.11.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.0/submodules/qt5compat-everywhere-src-6.11.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.0/submodules/qt5compat-everywhere-src-6.11.0.tar.xz"
  sha256 "e62954646b2749723aa5c7db32faab407358734075590058a01e793382d4c63e"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-2-Clause", # src/core5/codecs
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qt5compat.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ce6be2bef184fd605bccd465da49161963095a7a5825ffa2ab4efdd50516e581"
    sha256 cellar: :any,                 arm64_sequoia: "ed41b90ab51f152301f7a6ce7c0ddf3cbf0eeda457c90a58bbf6f51e8518b94a"
    sha256 cellar: :any,                 arm64_sonoma:  "288951e0220c68ef54e8d010b160a7aa5b378f7e92286a85eae09bee162a81f2"
    sha256 cellar: :any,                 sonoma:        "ed7ca647b517ae4565dbc7aa25e718f9aa80b7f6a8f267aa11938c2bfb2512e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c83f03e9b436c11278492ff7ea1bf505bf7c53664994d0893ea67a7b104472a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2a33fc1094d7a5878328ae3a0d7d54667fd879e41e8e16df1060157fab4fb29"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "icu4c@78"
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
      system Formula["qtbase"].bin/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6Core5Compat").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
