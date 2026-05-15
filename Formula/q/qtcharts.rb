class Qtcharts < Formula
  desc "UI Components for displaying visually pleasing charts"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.0/submodules/qtcharts-everywhere-src-6.11.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.0/submodules/qtcharts-everywhere-src-6.11.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.0/submodules/qtcharts-everywhere-src-6.11.0.tar.xz"
  sha256 "ac409bd4085772f7f091438cce05213b2a88a6edbab16e3dd7a96122386d94b5"
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
    sha256 cellar: :any,                 arm64_tahoe:   "a6e6418190532e62b7c908da4acd0a11c96772ec599124f03b0642c6bb338137"
    sha256 cellar: :any,                 arm64_sequoia: "81fcf8dc96975f4a54f3f5a9031fb8f8240641208aaeb9eb677594ea8efbe619"
    sha256 cellar: :any,                 arm64_sonoma:  "677e272f3c67d08112b67c0bdf76475879f8c431923506461a03162623fb022f"
    sha256 cellar: :any,                 sonoma:        "99267ed4a831987e5c24d8810a3496309a87c9e522f3aae20ca323763f1eeec1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2f012eb8014c35ff658d37b084cd29ef98d11503c61a95d3441224cbe94e253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d93092c0431069895b53fccd71fc1496e4adf5502ffb052b070c1cac4bdebf4b"
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
