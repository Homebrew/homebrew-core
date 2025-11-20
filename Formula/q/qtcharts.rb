class Qtcharts < Formula
  desc "UI Components for displaying visually pleasing charts"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtcharts-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtcharts-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtcharts-everywhere-src-6.9.3.tar.xz"
  sha256 "29d7cbbdb31d6a2e6c3ab5b5b52f34ff457db55d87d28a7c335b015d749d4c53"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtcharts.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6989029968b93881caad18fdd1d934a393278d91b6c011c04b830b36516dc952"
    sha256 cellar: :any,                 arm64_sequoia: "b9c242e1bb487a6685ace068cca91117ea9635069487bb307ee3bb5116e46bd2"
    sha256 cellar: :any,                 arm64_sonoma:  "adace123938506892453c5de1fb2c7cbc736fd6ea57f7b47af7c2a39ae331049"
    sha256 cellar: :any,                 sonoma:        "9f6eaf6f26e846c925c3d864df798afae8333d094552b82c72c70fe3500079ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47297c9dcac8c10f8a05b858c64e129229e12dda31f44a8b9145436b31a43126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5efe0fadc5a94b8c80105e862e8bad18ade727945d3bc78072c2bfe5ecdc9871"
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
