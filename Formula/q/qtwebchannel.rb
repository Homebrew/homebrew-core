class Qtwebchannel < Formula
  desc "Bridges the gap between Qt applications and HTML/JavaScript"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.0/submodules/qtwebchannel-everywhere-src-6.11.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.0/submodules/qtwebchannel-everywhere-src-6.11.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.0/submodules/qtwebchannel-everywhere-src-6.11.0.tar.xz"
  sha256 "e946143a8b015e2c9d5cc6110515f43618b441799da546138d0b05d8afa9fb24"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtwebchannel.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0c06691b87c791938e23a1aa6d85cc2d0c0942d7a8378291d5b083f176843d4"
    sha256 cellar: :any,                 arm64_sequoia: "12369409f2c746066ba0e4fa0eafc83fea2f4f9c32b42076be30a761ad516da0"
    sha256 cellar: :any,                 arm64_sonoma:  "365506e38a530fdafa3896202957828c90bc190762a50b27c0520a3550695957"
    sha256 cellar: :any,                 sonoma:        "a312cdb462dc6d30af281f9121d5314ed553dc31396647d2a8b5a937460b311f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2277a6a7eba48b7420a50482633e72f69b8a8df0aebd52d792c5d4e6956e7e01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f08ff0f1b997c8f81d95c7aa50f17141ded2490c57be4e14d456763ea64236ed"
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
