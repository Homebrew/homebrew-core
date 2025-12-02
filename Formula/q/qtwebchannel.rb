class Qtwebchannel < Formula
  desc "Bridges the gap between Qt applications and HTML/JavaScript"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtwebchannel-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtwebchannel-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtwebchannel-everywhere-src-6.9.3.tar.xz"
  sha256 "9457bbc1e5a13d9cf277c1fc121cdeb0a21546abf7fba091779b7ce9806fa305"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtwebchannel.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "251c29737a4e6243453c8ded8268ade0fa651cfa3d2d930ff4c6a657c4ea0c06"
    sha256 cellar: :any,                 arm64_sequoia: "28052c4594637a53dfdf9f2bcd777aa4099536804683a1d3bf91e7dc16bf5780"
    sha256 cellar: :any,                 arm64_sonoma:  "062a158a045c00529d538dbdb8c66ab3a761960546fbb5cf969cbd8fc03ec6a7"
    sha256 cellar: :any,                 sonoma:        "8892f43cf82fd849d38024a2c7aebc4e0c27f38770e9cb55b8d0edf9eb89ed3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08d9c962e3dd1f1b3c40ad953d624b6fa33b5940e0f588c251115d3f7b6da05d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c48878bc36675db7e0c090eecd81d000abf759ffb0ee2ae90b222e9aac6360c"
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
      find_package(Qt6 REQUIRED COMPONENTS WebChannel)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::WebChannel)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += webchannel
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QHash>
      #include <QObject>
      #include <QString>
      #include <QStringLiteral>
      #include <QWebChannel>

      int main(void) {
        QWebChannel channel;
        QObject plain;
        QHash<QString, QObject*> objects;
        objects[QStringLiteral("plain")] = &plain;
        objects[QStringLiteral("channel")] = &channel;
        channel.registerObjects(objects);
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

    flags = shell_output("pkgconf --cflags --libs Qt6WebChannel").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end
