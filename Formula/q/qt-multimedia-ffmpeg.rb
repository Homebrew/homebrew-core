class QtMultimediaFfmpeg < Formula
  desc "Qt FFmpeg plugin"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.6/6.6.2/submodules/qtmultimedia-everywhere-src-6.6.2.tar.xz"
  sha256 "e2942599ba0ae106ab3e4f82d6633e8fc1943f8a35d91f99d1fca46d251804ec"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "vulkan-headers" => [:build, :test]

  depends_on "ffmpeg"
  depends_on :macos
  depends_on "qt"

  def install
    # See also Formula["Qt"], here we just need the plugin.
    ENV.runtime_cpu_detection
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
    ]

    system "cmake", *cmake_args, "-S", ".", "-B", "build"
    system "cmake", "--build", "build", "--target", "QFFmpegMediaPlugin"
    system "cmake", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                    "-P", "build/src/plugins/multimedia/ffmpeg/cmake_install.cmake"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})

      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)
      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 REQUIRED COMPONENTS Core Multimedia)

      add_executable(test
          main.cpp
      )
      target_link_libraries(test PRIVATE Qt6::Core Qt6::Multimedia)
    EOS
    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QMediaCaptureSession>
      #include <QtGlobal>
      int main() {
        QCoreApplication::addLibraryPath("#{share}/qt/plugins");
        qputenv("QT_MEDIA_BACKEND", "ffmpeg");
        qputenv("QT_DEBUG_PLUGINS", "1");
        QMediaCaptureSession captureSession;
      }
    EOS

    system "cmake", "."
    system "cmake", "--build", "."
    assert_match "ffmpeg", shell_output("./test 2>&1")
  end
end
