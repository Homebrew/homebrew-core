class Qtpositioning < Formula
  desc "Provides access to position, satellite info and area monitoring classes"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtpositioning-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtpositioning-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtpositioning-everywhere-src-6.11.1.tar.xz"
  sha256 "d5e6b91801ae286e7630016caea3bdc5e1978b4291d6741d0d64c125650f78f5"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # bundled poly2tri; *.cmake
    "BSL-1.0",      # bundled clipper
    "MIT",          # bundled clip2tri
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtpositioning.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3eae7c50185a2099527a1456e72b746bcaf709569b69a7c5a1802d99b9dcf50b"
    sha256 cellar: :any,                 arm64_sequoia: "5d5393e5e47f67a32be62f450dda35cbc4acbdf455de33f7cf5f0bb10029d5fa"
    sha256 cellar: :any,                 arm64_sonoma:  "6fc04fa26c47681c1fb8d1d1dfd4fe40748ddc86c8c81364c7c241b9b16061cf"
    sha256 cellar: :any,                 sonoma:        "6bf61b4bee6dbb362d191853678e6abc0d4dacfd268a30980f833baef15f649a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e5c21b82dccaafa55453570a8a8cdba77349e76ee6ef02ac3a0d3c3831cebf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a5f4c05a3cef51b5de3768bb47cf2d08bd95ae39be052121e9eef6e118876cd"
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
