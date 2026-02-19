class Qtquicktimeline < Formula
  desc "Enables keyframe-based animations and parameterization"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtquicktimeline-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtquicktimeline-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtquicktimeline-everywhere-src-6.10.2.tar.xz"
  sha256 "7032d8b758d21fdf790dde0d070e1c82819abcf5ee7194dbf21589dbdfd36324"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtquicktimeline.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4e40930972c0553f87aefc2d91be2d1c96c029cb96f094569197cb41fcb36066"
    sha256 cellar: :any,                 arm64_sequoia: "07c1e52fa0917eb5c540b0777dbaec877770ab3dddb1419116bce4c476562af3"
    sha256 cellar: :any,                 arm64_sonoma:  "38af513e73f59fa33bc426dcdc8f6677f8d5a0463b8a68190944cc550cb4c150"
    sha256 cellar: :any,                 sonoma:        "71dcfdde1ce922b39bb1f0c4940d06bc53f0827bd5cb8c43d7b092336ed51f9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c2913c3baa203bc706ecd73b4d2eddc05d578a40ae423333dd475e6c261fbca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36ad9e57ccf09a13f8da9d6a2ee786a7d91fc62523447951b9c5065fc617b1ba"
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
