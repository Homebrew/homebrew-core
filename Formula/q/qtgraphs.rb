class Qtgraphs < Formula
  desc "Provides functionality for 2D and 3D graphs"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/qtgraphs-everywhere-src-6.10.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/qtgraphs-everywhere-src-6.10.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/qtgraphs-everywhere-src-6.10.1.tar.xz"
  sha256 "4d4fa0b21fa3c6b72ad5056e2a06e96e4bfda651e0a824d1f8e896c9ce5e576e"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtgraphs.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d33eb368a964ea4864c4339c4231fbd850df3c2d39ce10d1e45f83ef703ff50"
    sha256 cellar: :any,                 arm64_sequoia: "862811d2d11b212e3738c53c69639e1d17cf7547454e6dc630579a76c0c7b909"
    sha256 cellar: :any,                 arm64_sonoma:  "1047dd2d3d04bb681ae7e4c7143d207df1aa3fdb61dd515f070596ad4a51ca5e"
    sha256 cellar: :any,                 sonoma:        "96edf5265a29956986dc0a6e3e7036c0b67723bab0e7358422708c1d82f16346"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e52f46ecb907a2873564d926bfd2f4cc3d81bdc0d3265e0e1606eabcdfa86ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb39b3daf141fe3c54b9fe31f52712b9be8b779e45c2a228dbd6b553daec9995"
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
