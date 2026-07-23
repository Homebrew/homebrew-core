class Qttranslations < Formula
  desc "Qt translation catalogs"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qttranslations-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qttranslations-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qttranslations-everywhere-src-6.11.1.tar.xz"
  sha256 "37c02c81206594c7bb4edca85ac93e8e55a9836b70c960fde6cb0f8623ec5677"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://code.qt.io/qt/qttranslations.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44feb5838957db5caf22f10f49f32825640b1b373f18c0981707d0725e928674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "700100f1cd45907a5c4bdbadd422bc39a2a6bafee810926105748f832ab67872"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3702655383dde7952d72c72e39d186857b67a0b20ea5ecf478f8892b6cdc6035"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fe673356376d43d9e81391f815d89cfe95033fe60e26a79a21937bbe29f2482"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9d02646e9432d15a16cd85a8bcbdffba243485e1b5d2bf0f2d9111fa5dc13e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac0ec7d2a9e77b875da9067e7c77608002c26e141296a989ef3c61b87f892619"
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
