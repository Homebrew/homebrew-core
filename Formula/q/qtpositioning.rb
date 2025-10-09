class Qtpositioning < Formula
  desc "Provides access to position, satellite info and area monitoring classes"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtpositioning-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtpositioning-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtpositioning-everywhere-src-6.9.3.tar.xz"
  sha256 "0c87c980f704c17aadaf0bf8a03845dd0a60cc0313be24bd7b5b90685d5835b4"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # bundled poly2tri; *.cmake
    "BSL-1.0",      # bundled clipper
    "MIT",          # bundled clip2tri
  ]
  head "https://code.qt.io/qt/qtpositioning.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0527cd554ef27823760fc1b58b749f484c2a54da05745188b6e8da6fd8505667"
    sha256 cellar: :any,                 arm64_sequoia: "752f8c9bddbc745cb99897f30d918b7bbf5481faf19031df5af6d6fa7034953b"
    sha256 cellar: :any,                 arm64_sonoma:  "6d51d148e6cc63c0b1a0178fae03dbc5f1b7f231fe27904f87449eca158e1564"
    sha256 cellar: :any,                 sonoma:        "939737840db8646bcf700862955b1037d7fc15c3e63ec249973b4ffe97c8f637"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b857a07595e1962e101b453e07db1a0acbfaff243a18b572c7ff9407350b8b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d21a7d8372cbd1fe44966d5eba3fab9f189d8331c504249e905e36bf1430189"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtserialport"

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
      find_package(Qt6 REQUIRED COMPONENTS Positioning)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Positioning)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += positioning
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QGeoPositionInfoSource>

      int main(void) {
        Q_ASSERT(QGeoPositionInfoSource::availableSources().contains("nmea"));
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

    flags = shell_output("pkgconf --cflags --libs Qt6Positioning").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
