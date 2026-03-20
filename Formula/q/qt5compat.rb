class Qt5compat < Formula
  desc "Qt 5 Core APIs that were removed in Qt 6"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qt5compat-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qt5compat-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qt5compat-everywhere-src-6.10.2.tar.xz"
  sha256 "3fa418f0fac02eb9efc5f762fbe25f20647b0ebb7fa92faf07e6de85044161c2"
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
    sha256 cellar: :any,                 arm64_tahoe:   "e7b0ce02089935bb161e5ae4e0684a6256ec5ecd578899c146fff6ae5c04dcd1"
    sha256 cellar: :any,                 arm64_sequoia: "e8be87144567fdba31ed1aaf293eb9dfd2d6d181672e6718fdc611c1c9ef8f3a"
    sha256 cellar: :any,                 arm64_sonoma:  "e8432e7ddb394dc5b3058ac8283a9b030c5b6569b5169433dbd691a581005cd1"
    sha256 cellar: :any,                 sonoma:        "ecb2129bcc031e77abcdae42b76255b17e91fb3d603dd9b227bf4f2eeefc41ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7707904d06558de433cfd2e80166c45745a79df009b2482a7b4c5a9749f2675b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9263f048dd7e2516f295544764814d8f416e2e0151fe64231b98192d04ea0f6d"
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
