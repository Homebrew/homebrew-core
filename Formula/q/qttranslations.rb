class Qttranslations < Formula
  desc "Qt translation catalogs"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.0/submodules/qttranslations-everywhere-src-6.11.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.0/submodules/qttranslations-everywhere-src-6.11.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.0/submodules/qttranslations-everywhere-src-6.11.0.tar.xz"
  sha256 "54f48b2fe4316892ff930195f170a5385644acc7393505f3155c066b8e1ffe56"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://code.qt.io/qt/qttranslations.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "942627e43fec394ab95d86c3da8d0749128eee3eb61de193f523bcd19d4917d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "942627e43fec394ab95d86c3da8d0749128eee3eb61de193f523bcd19d4917d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9b26acb32f07bce8003915166eeb59859b8fdbe1a250c6ac95f32bc1d2227a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "92b042e081747fd88923ad5efa9d454f98d33aa6faa21e77609c978a625b346b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75711e23ebf281479bef3f5f8996763e3c442d08010e5d0f752a1c672e7b49b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7640419eba866bdb442c2e61f78a3e7b22fb3d385029697f8e5cb4c98e0b306b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "qtbase" => [:build, :test]
  depends_on "qttools" => :build

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS Core)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Core)
    CMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <iostream>
      #include <QLibraryInfo>
      #include <QLocale>
      #include <QTranslator>

      int main(void) {
        QTranslator translator;
        Q_ASSERT(translator.load(QLocale::Spanish, "qt", "_", QLibraryInfo::path(QLibraryInfo::TranslationsPath)));
        std::cout << translator.translate("CloseButton", "Close Tab").toStdString();
        return 0;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    assert_equal "Cerrar pestaña", shell_output("./build/test")
  end
end
