class Qttools < Formula
  desc "Facilitate the design, development, testing and deployment of applications"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qttools-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qttools-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qttools-everywhere-src-6.11.1.tar.xz"
  sha256 "8e61835a679c93fa9c6065b142353c2071ba68e297898937c32a03777fcaf50d"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "BSD-3-Clause", # *.cmake
    "BSL-1.0", # bundled catch2
  ]
  head "https://code.qt.io/qt/qttools.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "20aecfa9eb080d4f211b712ea9615fff4402f88c1fcdd1502f19cb762aa334f3"
    sha256 cellar: :any,                 arm64_sequoia: "462a076f64329011cbbec6812e4c591f80eb81739449fd8a5eb9e03771200b89"
    sha256 cellar: :any,                 arm64_sonoma:  "fe241aac196a66f1506d8f30048f8ebd248095fc29963b5cd4d1820eab77ffc9"
    sha256 cellar: :any,                 sonoma:        "9f20463c84fd13541159c9020b552629eaf328d4ae42c593f1251f552c83db47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc8fa63b4cc8e2ae11b3df94f6db5852e28863fda4832cb793df9b5a5e2c9961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dcfd3c8fe73c6cb04ed8b85c6bf1d4b0b73e2b53c37cc96dcce15a9c6af17df"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "vulkan-headers" => :build

  depends_on "litehtml"
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "zstd"

  on_macos do
    depends_on "gumbo-parser"
  end

  def install
    rm_r("src/assistant/qlitehtml/src/3rdparty/litehtml")

    # Modify Assistant path as we manually move `*.app` bundles from `bin` to `prefix`.
    # This fixes invocation of Assistant via the Help menu of apps like Designer and
    # Linguist as they originally relied on Assistant.app being in `bin`.
    inreplace "src/shared/helpclient/assistantclient.cpp", '"Assistant.app/Contents/MacOS/Assistant"', '"Assistant"'

    # We disable clang feature to avoid linkage to `llvm`. This is how we have always
    # built on macOS and it prevents complicating `llvm` version bumps on Linux.
    args = %W[
      -DFEATURE_clang=OFF
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DQLITEHTML_USE_SYSTEM_LITEHTML=ON
    ]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return unless OS.mac?

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework")

    bin.glob("*.app") do |app|
      libexec.install app
      bin.write_exec_script libexec/app.basename/"Contents/MacOS"/app.stem
    end
  end

  test do
    # Based on https://doc.qt.io/qt-6/qtlinguist-hellotr-example.html
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(hellotr LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS Core LinguistTools)
      qt_standard_project_setup(I18N_TRANSLATED_LANGUAGES la)
      qt_add_executable(hellotr main.cpp)
      qt6_add_translations(hellotr QM_FILES_OUTPUT_VARIABLE qm_files)
      target_link_libraries(hellotr PUBLIC Qt::Core)
    CMAKE

    (testpath/"main.cpp").write <<~CPP
      #include <iostream>
      #include <QTranslator>

      int main(void) {
        QTranslator translator;
        Q_UNUSED(translator.load("hellotr_la"));
        std::cout << translator.translate("main", "Hello world!").toStdString();
        return 0;
      }
    CPP

    (testpath/"hellotr_la.ts").write <<~XML
      <?xml version="1.0" encoding="utf-8"?>
      <!DOCTYPE TS>
      <TS/>
    XML

    ENV["LC_ALL"] = "en_US.UTF-8"
    system "cmake", "."
    system "cmake", "--build", ".", "--target", "update_translations"
    inreplace "hellotr_la.ts", '<translation type="unfinished"></translation>',
                               "<translation>Orbis, te saluto!</translation>"
    system "cmake", "--build", "."
    assert_equal "Orbis, te saluto!", shell_output("./hellotr")
  end
end
