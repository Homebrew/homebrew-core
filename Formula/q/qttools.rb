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
    url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qttools-everywhere-src-6.9.3.tar.xz"
    mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qttools-everywhere-src-6.9.3.tar.xz"
    mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qttools-everywhere-src-6.9.3.tar.xz"
    sha256 "0cf7ab0e975fc57f5ce1375576a0a76e9ede25e6b01db3cf2339cd4d9750b4e9"

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
    sha256 cellar: :any,                 arm64_tahoe:   "1118eea06e96114a12fe3283ca95d4635a1df5c61ef9bac1aa32e89c6270b3d2"
    sha256 cellar: :any,                 arm64_sequoia: "0f55c7a0531956e28a0d43709732dc5aa64d46e00036919512fd8e5667de5a96"
    sha256 cellar: :any,                 arm64_sonoma:  "77936861c7a0e8ef304d1de1984e77f11408085fcdcbd3fe74f40f2b935e7ff7"
    sha256 cellar: :any,                 sonoma:        "c03e46e01c366253d940a8466fbe385ef049f67bbb728ca5a5e0fd8fbd3611e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fffabae308dcaee15d75c9662c0b78c12759073552a598519950e4d98d114c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ea8fb896bfb7495515265341360c6090845fa68fc67b9bbee03a1a91d0405a2"
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
