class Qtquicktimeline < Formula
  desc "Enables keyframe-based animations and parameterization"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtquicktimeline-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtquicktimeline-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtquicktimeline-everywhere-src-6.9.3.tar.xz"
  sha256 "284f4ba65ea71fa32751525c845f540c99d2f86fed88387e8c3d5869cf6c11f7"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtquicktimeline.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e5ab96426a4d5bc5380466047a012c132a84a1728a77e6b27c19a16ab86fdc4"
    sha256 cellar: :any,                 arm64_sequoia: "b88713278fbdd593b1e7039f6a10d58dcad1e60f8052cb3cb778edfdf5db3aa2"
    sha256 cellar: :any,                 arm64_sonoma:  "c709c762e9bfdf072debaca4350e3a771dca1f938e34105a6c69851d907a334f"
    sha256 cellar: :any,                 sonoma:        "c7359b758c5a20e3246b652739f688937f3a29e4846b4ba42d1b54144181881a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b109e589563914d9675744a0a7fa23c5b08517708d7a8ba69f739af1eb9ab5b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ef59c4ebf0c10f60ddf24312cea5bbcd8eef955df2a5f702fc3c890dc8470ec"
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
