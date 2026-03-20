class Qttools < Formula
  desc "Facilitate the design, development, testing and deployment of applications"
  homepage "https://www.qt.io/"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "BSD-3-Clause", # *.cmake
    "BSL-1.0", # bundled catch2
  ]
  head "https://code.qt.io/qt/qttools.git", branch: "dev"

  stable do
    url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qttools-everywhere-src-6.10.2.tar.xz"
    mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qttools-everywhere-src-6.10.2.tar.xz"
    mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qttools-everywhere-src-6.10.2.tar.xz"
    sha256 "1e3d2c07c1fd76d2425c6eaeeaa62ffaff5f79210c4e1a5bc2a6a9db668d5b24"

    # Backport fix for build on Linux
    patch do
      url "https://github.com/qt/qttools/commit/b676278a24eb880eeeed35bbf203a76950a9ab4e.patch?full_index=1"
      sha256 "36740336b401055ca1699787921d474377ec65f0b041351141b158b9ced7ef42"
    end
  end

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1bb2951b965ac91201b28aa2060fb88c3784478baea5bd86395fe17b23618539"
    sha256 cellar: :any,                 arm64_sequoia: "863ae193ac3ee1539c737f1df645e908c692ca5a9f2a5eac8b61857cd0af6f00"
    sha256 cellar: :any,                 arm64_sonoma:  "4ac4c5c004064b5c526ca8a0cc862392cc5eced81bf0c35d45fd5c5a60a6560f"
    sha256 cellar: :any,                 sonoma:        "9d1cda0f05a6415afbafe2c8072b607d6b3f5b1c147803bd179292c221627c17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4036fe0f58be98de7b5f6f5e49b7cd496a7e322fc58f30723e1c5e30efab7e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "242c56b484d044f863a6c8d5b8e3c890d6e6ffeb35c5085bd602e922c16dea1f"
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
    assistant_files = %w[
      src/designer/src/designer/assistantclient.cpp
      src/linguist/linguist/mainwindow.cpp
    ]
    inreplace assistant_files, '"Assistant.app/Contents/MacOS/Assistant"', '"Assistant"'

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
