class Qt5compat < Formula
  desc "Qt 5 Core APIs that were removed in Qt 6"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/qt5compat-everywhere-src-6.10.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/qt5compat-everywhere-src-6.10.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/qt5compat-everywhere-src-6.10.1.tar.xz"
  sha256 "72396d160a153dee01b41cf0cae9ad46204cf613adb791b3ee85a7efeadffe24"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-2-Clause", # src/core5/codecs
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qt5compat.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba433ca240d7332880fa1da4e24786a2d6d357ebe5582c434bb99f86f51d150c"
    sha256 cellar: :any,                 arm64_sequoia: "0675a8d0b979411237d1c9864c9707f18065f0e36894d45ba5c59ab05505fb65"
    sha256 cellar: :any,                 arm64_sonoma:  "5f909719a6de494ff0b392f367f28ad2666dd0d87e6cdb33dfcfaf32f2287e3c"
    sha256 cellar: :any,                 sonoma:        "f2488685fe71195627df3fcd328d03b117e8b64a10db989a9014265e502c2630"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e0a666ce95ce4994bfeeef79fe10cba737fca25c104fb02acbc04b35dca155d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97162c20a7bec107dfd6c9cb04aaa446c95994e98ae36b6a2acf9015cb2b5439"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "icu4c@78"
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtshadertools"

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS Core5Compat)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Core5Compat)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += core5compat
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QChar>
      #include <QString>
      #include <QStringRef>

      int main(void) {
        const QString hw = QStringLiteral("Hello World");
        const QStringRef ref = QStringRef(&hw).mid(6);
        Q_ASSERT(ref.at(0) == QChar('W'));
        Q_ASSERT(ref.at(4) == QChar('d'));
        return 0;
      }
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", "-S", ".", "-B", "cmake"
    system "cmake", "--build", "cmake"
    system "./cmake/test"

    ENV.delete "CPATH" if OS.mac?
    mkdir "qmake" do
      system Formula["qtbase"].bin/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6Core5Compat").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
