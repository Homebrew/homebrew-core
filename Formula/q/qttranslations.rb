class Qttranslations < Formula
  desc "Qt translation catalogs"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qttranslations-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qttranslations-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qttranslations-everywhere-src-6.9.3.tar.xz"
  sha256 "f36d545e6681b146fd79b3ebb74ef275e88694cf81eae8323327cae3bfc490a1"
  license "BSD-3-Clause"
  head "https://code.qt.io/qt/qttranslations.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b444965fa2e6815ced5a489dc9f9020d676cf86c0961738c0a8777bfdb3442cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14b105e3e2d71c7a7d0781928d01de26f2223bc4a5682e54b7443394f84f81fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65ff305605000a5ff86438ba7826130ce0741a67bca9f4a497a4201d7e429382"
    sha256 cellar: :any_skip_relocation, sonoma:        "36f2d1ff2cc9213b23e5e51be6d816bf53762673fdc344ff52f389b30e3cc64e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5314a36b867f31b8978508cc8d2aee0aa540e2d6a50487aec451582abc56d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e5714a90b2b3bef43f1184686edc21d633f7c4e51cccc4a896e45f236defc56"
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
