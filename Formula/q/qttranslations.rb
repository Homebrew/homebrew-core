class Qttranslations < Formula
  desc "Qt translation catalogs"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qttranslations-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qttranslations-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qttranslations-everywhere-src-6.10.2.tar.xz"
  sha256 "b3b3813bc9d76b545716dc8b6e659fa71b6e2bc14569e9fab6dab8b30650a644"
  license "BSD-3-Clause"
  head "https://code.qt.io/qt/qttranslations.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e665f1b97d4259723d8c7fcc08e1497fa32166896a92b0c807a547c598e75f95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e665f1b97d4259723d8c7fcc08e1497fa32166896a92b0c807a547c598e75f95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72243bc131a9d196176713ca48d2a17c92c7243eaef84e98944514b74e51c1eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "508e298d4224554488b122866bc08c99357003aeb5da5b322b4f4f78cfa7dc42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "742d2b461f33eb5573b75e72b0261a89437fc4ab8bc7f3926f1a2d085ac3667a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "405d3640be84963f1d659ab55aa89a6077bee11c9fc0014ec6f80efe75083e9a"
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
