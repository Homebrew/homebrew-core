class Qtlottie < Formula
  desc "Display graphics and animations exported by the Bodymovin plugin"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtlottie-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtlottie-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtlottie-everywhere-src-6.9.3.tar.xz"
  sha256 "116e105574f0bb442b80251fa60b88d1c9fe55db64e11b549e8fc2063b90df33"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtlottie.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "638ca0b85bad94892f667db6cab7b794d8d4e12d248ce452877a1f88d171b59f"
    sha256 cellar: :any,                 arm64_sequoia: "2bdb25e54cd94248e580137ce08b74f380b3868286702cc043630d89ff3a56de"
    sha256 cellar: :any,                 arm64_sonoma:  "388c2261688b21086cfd85bfae8f9a8db9833cee13fb47ad27cd2b7cc6912832"
    sha256 cellar: :any,                 sonoma:        "159a91be2af2925b26a0eb2ebb25d987184e68d77e5b915db772c52853e85276"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6526e1149d8e85929bb675933a2fcad7d2e610b1a5b1690297d2f87ec19687f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "619b473ce6b5b3230a3667ba7b6e86a5532202057157d839769b9a4867165b35"
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
    resource "rect_rotate.json" do
      url "https://raw.githubusercontent.com/qt/qtlottie/888fb0ca5d5e18fe5d8b88ed721544bf204ac158/tests/manual/testApp/rect_rotate.json"
      sha256 "d0d5d2b036c04d4b2c1211d062fe1c123053ea0d4639cd33a2cec724236bf328"
    end
    testpath.install resource("rect_rotate.json")

    # Based on https://github.com/qt/qtlottie/blob/dev/tests/manual/testApp/main.qml
    (testpath/"test.qml").write <<~QML
      import QtQuick
      import QtQuick.Window
      import Qt.labs.lottieqt

      Window {
        visible: true
        width: animContainer.width
        height: animContainer.height
        title: qsTr("Animation test")
        color: "black"

        Item {
          id: animContainer
          width: childrenRect.width
          height: childrenRect.height

          LottieAnimation {
            id: bmAnim
            quality: LottieAnimation.MediumQuality
            source: "rect_rotate.json"
            onFinished: Qt.quit()
          }
        }
      }
    QML

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux?
    system Formula["qtdeclarative"].bin/"qml", "test.qml"
  end
end
