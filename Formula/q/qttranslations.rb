class Qttranslations < Formula
  desc "Qt translation catalogs"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/qttranslations-everywhere-src-6.10.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/qttranslations-everywhere-src-6.10.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/qttranslations-everywhere-src-6.10.1.tar.xz"
  sha256 "8e49a2df88a12c376a479ae7bd272a91cf57ebb4e7c0cf7341b3565df99d2314"
  license "BSD-3-Clause"
  head "https://code.qt.io/qt/qttranslations.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b82377b5f587b734aafba94aa7e91a3b9b2b2eec0a7d078707d1ac7558cdf0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b82377b5f587b734aafba94aa7e91a3b9b2b2eec0a7d078707d1ac7558cdf0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "893d13e0aeeed7ec084c0791e34d3db105338f0349581ded1d494543f0a01b40"
    sha256 cellar: :any_skip_relocation, sonoma:        "64fea3043b5581c21230b5c11062e6a49b38b40cb2ca4cde52839855c3bc890b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e818a5a983250ca3ef20be4abecb8a94eb60981b4a99a653d6e91c8e3763509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e7e36d608177b9cd857fc26f1d5787634ab271352e0e378fc3a7b61c4ef1c39"
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
