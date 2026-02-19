class Qtsvg < Formula
  desc "Classes for displaying the contents of SVG files"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtsvg-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtsvg-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtsvg-everywhere-src-6.10.2.tar.xz"
  sha256 "f07ff80f38caf235187200345392ca7479445ddf49a36c3694cd52a735dad6e1"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtsvg.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "060b6db495b7836126c5dc6d77b5c4aa95b174954a025c74e94cd734a254774d"
    sha256 cellar: :any,                 arm64_sequoia: "3df926eee1e4cf651ecbc2572ce7d563fb609cbd6667bfedbaaef89338faa27a"
    sha256 cellar: :any,                 arm64_sonoma:  "9eb363fcb8b5f8db9af7aa6df62e2b5b8b9f23df1c1c4024322ff5844058ca70"
    sha256 cellar: :any,                 sonoma:        "fb242965e51cd00afe125e371706e4820e098ff5b17e3e5d25d50f5a347ba4b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b415293317474a509c79cd6be4890a4c6bc56d9e98a99dc4bf96d00ea9a20bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed801d52d49d9340b88c0e814d01a49be8fb8b23ac3715ad0100398751e7ea21"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
      find_package(Qt6 REQUIRED COMPONENTS Svg)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Svg)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += svg
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QImageReader>
      #include <QtSvg>

      int main(void) {
        QSvgGenerator generator;
        const auto &list = QImageReader::supportedImageFormats();
        Q_ASSERT(list.contains("svg"));
        Q_ASSERT(list.contains("svgz"));
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

    flags = shell_output("pkgconf --cflags --libs Qt6Svg").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
