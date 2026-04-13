class Qtquicktimeline < Formula
  desc "Enables keyframe-based animations and parameterization"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.0/submodules/qtquicktimeline-everywhere-src-6.11.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.0/submodules/qtquicktimeline-everywhere-src-6.11.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.0/submodules/qtquicktimeline-everywhere-src-6.11.0.tar.xz"
  sha256 "06dbe1cc541431fa321023992ca4ccf83c76b25d07bbf516e0af887a38f32cd6"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtquicktimeline.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "91782d84372ab39cbd536d44c785b9c8ed9cdfc6f9677c63f07886f80e98a0b0"
    sha256 cellar: :any,                 arm64_sequoia: "f8fa5b90d1431c36fe072bdb5ce4c339296ae1a24457e0c4748bc4e934fa2485"
    sha256 cellar: :any,                 arm64_sonoma:  "84bd2c5f75477b8b0b6827fb8af978d2a924194af30afd0bfa6953602c504c16"
    sha256 cellar: :any,                 sonoma:        "7f7a7a0d7dbfb749d435c96ec315dae6ccb869a579a4ee5b8a24d090e9062dfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7add69a692c6b21a74d7d20ada4de150f4efee26af78d182764ade6260ddfd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a585698cb81b92e2dc0ec6df828b2ece10fcbdeadaa4eac5a75df2845b9f7e8f"
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
