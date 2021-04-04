class QtIos < Formula
  desc "Qt for iOS"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.3/single/qt-everywhere-src-6.0.3.tar.xz"
  sha256 "ca4a97439443dd0b476a47b284ba772c3b1b041a9eef733e26a789490993a0e3"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  keg_only "this is the SDK of Qt for iOS"

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "qt"
  depends_on :xcode

  uses_from_macos "perl"

  resource "qtimageformats" do
    url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.3/qtimageformats-everywhere-src-6.0.3.tar.xz"
    sha256 "327580b5a5b9a8d75e869c0eaa7ff34881bbde4e4ccc51d07a59e96054136837"
  end

  resource "qt3d" do
    url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.3/qt3d-everywhere-src-6.0.3.tar.xz"
    sha256 "470f95c559b68cc8faa982c1ca7ff83054d6802f7b2a0c1d960a155b92080cf9"
  end

  resource "qtnetworkauth" do
    url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.3/qtnetworkauth-everywhere-src-6.0.3.tar.xz"
    sha256 "124bf433e2c5418e900a5947d4ceb128ee179f514eddcea33924f0b695be64ed"
  end

  def install
    # cmake cannot recognizes iOS SDK when using shims cc
    ENV.prepend "PATH", "/usr/bin:"

    cmake_args = std_cmake_args.reject { |s| s["CMAKE_OSX_SYSROOT"]||s["CMAKE_FIND_FRAMEWORK"] } + %w[
      -DCMAKE_FIND_FRAMEWORK=FIRST
    ]

    system "./configure", "-xplatform", "macx-ios-clang",
      "-qt-host-path", Formula["qt"].prefix, "--", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    rm bin/"qt-cmake-private-install.cmake"
    libexec.install bin/"target_qt.conf"
    libexec.install bin/"qmake"
    bin.write_exec_script libexec/"qmake"
  end

  test do
    (testpath/"test.pro").write <<~EOS
      QT       += core
      TARGET = test
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        return 0;
      }
    EOS

    system bin/"qmake", "test.pro"
    assert_predicate testpath/"test.xcodeproj", :exist?
  end
end
