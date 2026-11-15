class Qttranslations < Formula
  desc "Qt translation catalogs"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qttranslations-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qttranslations-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qttranslations-everywhere-src-6.12.0.tar.xz"
  sha256 "85929c0c30d6f273f23bd879bb69803ea17b010ab73cab2f8abf95357f6f6bbb"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://code.qt.io/qt/qttranslations.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "62b7150d75ca2a2ee84fa565f1a911af6af94e266501128de82f49b6be5c52a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "62b7150d75ca2a2ee84fa565f1a911af6af94e266501128de82f49b6be5c52a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c011fbfec5da00acc93cad982cf0353ef59272266d05ba6f9865bc66f02e9956"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f8a0acc6f9b16abaa2f97351af3e504b6fe0cd767c936529ddabb87fc612f154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b1efa9e192887b4541c67cddddaf2c118dc8cdaf11134a93a33bffda6fd35667"
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
