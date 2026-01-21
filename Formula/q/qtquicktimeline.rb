class Qtquicktimeline < Formula
  desc "Enables keyframe-based animations and parameterization"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/qtquicktimeline-everywhere-src-6.10.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/qtquicktimeline-everywhere-src-6.10.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/qtquicktimeline-everywhere-src-6.10.1.tar.xz"
  sha256 "882ed289b4c229ace324e2545a71d7611c201626bc007d50e514bfd2f6e251b7"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtquicktimeline.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6cfad7a8a172170deddc37a92ad8c7d720cf584c03b58bed0e79d4e302933359"
    sha256 cellar: :any,                 arm64_sequoia: "1e98992593d51a2a509097c1bfd8e17165c6fec2d4d7cef573034274dc1a2b31"
    sha256 cellar: :any,                 arm64_sonoma:  "dc1d95dfb6a1c2116530c86982ea183d517701174cace46cb456b2bba838bbea"
    sha256 cellar: :any,                 sonoma:        "ebcb24b08e1d7a9f7d0ef8b178774d91a6092f590fc6bcd1bfd72217e35a3631"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6915f106b0e43f950ab3d262db4263d819d1d85d15b5f869561471e68b7128ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "357f0e4edbecfcde251fe345a5ecff83e65f310ba8ccf91667593ada4f8bf042"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

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
    (testpath/"test.qml").write <<~QML
      import QtQuick 2.0
      import QtQuick.Timeline 1.0

      Item {
        Timeline {
          id: timeline
          startFrame: 0
          endFrame: 100
          enabled: true
          animations: [
            TimelineAnimation {
              duration: 1000
              from: 0
              to: 100
              running: true
              onRunningChanged: { if(!running) { Qt.quit() } }
            }
          ]
          KeyframeGroup {
            target: rectangle
            property: "color"
            Keyframe { frame: 0; value: "red" }
            Keyframe { frame: 100; value: "blue" }
          }
        }
        Rectangle {
          id: rectangle
          width: 50
          height: 50
          color: "red"
        }
      }
    QML

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux?
    system Formula["qtdeclarative"].bin/"qml", "test.qml"
  end
end
