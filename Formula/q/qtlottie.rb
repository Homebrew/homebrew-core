class Qtlottie < Formula
  desc "Display graphics and animations exported by the Bodymovin plugin"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtlottie-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtlottie-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtlottie-everywhere-src-6.10.2.tar.xz"
  sha256 "a5d86b7a07833a0f2bd203042bbc156ec6588fd957f00a3c166788410ea4028c"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtlottie.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "411cba09b41d931a62bd99c6cfc54a72508a27737ee0d080e9b6852ea9dbcc46"
    sha256 cellar: :any,                 arm64_sequoia: "7e17817870d9667e6f7cb71b97641771c7401193dd4c33480392f800a4423861"
    sha256 cellar: :any,                 arm64_sonoma:  "5d566c3fef34bd8a09741fe76cd8e128bb828148de07c91aab779d56cbc36c71"
    sha256 cellar: :any,                 sonoma:        "cf9cd047b101ce43d44aef22ded88274d278ca095165c255ca693f03a088f5df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87457ac2e0ad79d5077a878c49cd13ab60f46095c7d99f30e5448de95f6fac77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4f4be09cc0386813231177ff8b2694c9a9d51de3150d15826c44dbc72765bf2"
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
