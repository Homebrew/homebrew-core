class Qtgraphs < Formula
  desc "Provides functionality for 2D and 3D graphs"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.0/submodules/qtgraphs-everywhere-src-6.11.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.0/submodules/qtgraphs-everywhere-src-6.11.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.0/submodules/qtgraphs-everywhere-src-6.11.0.tar.xz"
  sha256 "df6fcb48c0a558fdf964a7d4b52e740760fd7bbd0f7a5d9aff571050f476b15b"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtgraphs.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b3828723b7363e794a87386e89ca414911716e6fb1fdf1b915bc458c0ddeffde"
    sha256 cellar: :any,                 arm64_sequoia: "73d6529c99682efad9d1e261b873e9cc8d119f02ace68f5cfa19a036e2de0ceb"
    sha256 cellar: :any,                 arm64_sonoma:  "b3da06b96fddb0f6700a1743f0da62af3eaa31c9b430d4c8089c9d60882852ec"
    sha256 cellar: :any,                 sonoma:        "ae72b3ddfe049e433b1fb6ca29289882c481203aade368740ca4373d49e0f68f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18d52cef1f439420a3af5cd4d4a9fbd82650bafb0e49b8c80e82454c9dfcce42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b850f868e8bd3bb4dc1a4e6865d21ae25a52fd2f6045ea5d012666b9b2063f4"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtquick3d"

  on_macos do
    depends_on "qtshadertools"
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
      find_package(Qt6 REQUIRED COMPONENTS Graphs)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Graphs)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += graphs
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QLineSeries>

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

    flags = shell_output("pkgconf --cflags --libs Qt6Graphs").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
