class Qtcharts < Formula
  desc "UI Components for displaying visually pleasing charts"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtcharts-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtcharts-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtcharts-everywhere-src-6.10.2.tar.xz"
  sha256 "405116b4c5eded981484c4c154eb392d44b69b587342f1193181175e309f2c00"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtcharts.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d1c0a71fe7f52028ab7d5b5eb7c2e367b5d69ef190f23c6f03c9184c2e645b1c"
    sha256 cellar: :any,                 arm64_sequoia: "646968a9223d855dedfe4abca69ac28e808fb6a375aca3157d169cb249e4b7ee"
    sha256 cellar: :any,                 arm64_sonoma:  "38662cdff91605ae60738fcfa177f885275b682ed9790d6a56a237c93fadad71"
    sha256 cellar: :any,                 sonoma:        "c19d84b69fc805fa4bfb461051540b0f279b2e6c80995cbbe8a442354804e761"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2784026b5fa043023b79e3b317e25090c105fce912abbc2e860314b227cd25d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2fbc93b8877b452723f3f00473f2f12667bba413bf41bccc7834a41a5d1d7b4"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtdeclarative"

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
      find_package(Qt6 REQUIRED COMPONENTS Charts)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Charts)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += charts
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QLineSeries>
      #include <QList>

      int main(void) {
        QLineSeries series;
        series.append(QList<QPointF>());
        series.append(0.0,0.0);
        series.append(QPointF());
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

    flags = shell_output("pkgconf --cflags --libs Qt6Charts").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
