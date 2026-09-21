class Qttranslations < Formula
  desc "Qt translation catalogs"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.2/submodules/qttranslations-everywhere-src-6.11.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.2/submodules/qttranslations-everywhere-src-6.11.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.2/submodules/qttranslations-everywhere-src-6.11.2.tar.xz"
  sha256 "021684c1a7937a9fabc3b056a6698ad5978794caf9ac190fd6cc11399e67c014"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://code.qt.io/qt/qttranslations.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be0b1bd15634decab6d0bb6ef61f05fb74be35bc00e5f6db09651cb59c09a011"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "60c52acffb352decaa1670716836ce1a2f696f2d2f703fa06267373a65a25cfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf66db2b576e2895f90cdeb4fece21af78259bff883675b5f55733bd47c4ea0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "321d87ab9eb265668c54390a2002fdee47d12adf2b56e3f4132ebbd423747e49"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a2cd2c620d4444abf98f941baf4b4965e4406d5e3123a19f9c6603b62ca42d53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "34ca44f8e8245ce1c5ad394d5d1f86ce4eaee55549d85534dd8805876f3ac1bd"
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
