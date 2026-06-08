class Qtcharts < Formula
  desc "UI Components for displaying visually pleasing charts"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtcharts-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtcharts-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtcharts-everywhere-src-6.11.1.tar.xz"
  sha256 "3fe3ed318c2a86d1417c5c29cf7494275e8fd4b537cd37453f5599c57365515c"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtcharts.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0c14b7f8a8086197f082f166657bf84207d065248dbc6ab824c24e0390727ec"
    sha256 cellar: :any,                 arm64_sequoia: "55ac17ec5b4568a03f38524c11d3b5f7c6e3ca75af3c5a3c9e4291a040dc344d"
    sha256 cellar: :any,                 arm64_sonoma:  "65f4e67e89f1d5fa512a5c3e33cb81d1233eb62e900b061476199021f5ec77f1"
    sha256 cellar: :any,                 sonoma:        "4fe441dcef276c8c1d255f937b91587fd72ca11d350a819b1e81761ca8abdf1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e12e7861f73c10c2c7139c3f9b1b6792d1884e3e6e4f32417ec5fa2d4f083fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1535f2747db6079fa896bc2fedde77acf3db859f7dc0fc7c3e4e0568cc732633"
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
