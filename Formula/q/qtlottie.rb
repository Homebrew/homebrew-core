class Qtlottie < Formula
  desc "Display graphics and animations exported by the Bodymovin plugin"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtlottie-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtlottie-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtlottie-everywhere-src-6.12.0.tar.xz"
  sha256 "6b8f04c917f2666f8cca4e7804bcabb6edffe151406b89fb28de3bba5a5d997e"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  revision 1
  compatibility_version 1
  head "https://code.qt.io/qt/qtlottie.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "10e6085eb0014cd0b100dd00e34cd70295d2b56ce6a8cb6e242632183df8805f"
    sha256 cellar: :any, arm64_tahoe:       "abf3075e4efd657f7bdd3eea1a0100d8026ba64fe28ba2a8dacb8dc24e6c93ba"
    sha256 cellar: :any, arm64_sequoia:     "daad2907205829155b17f3292ba7c67f64b57575d7ffb48346b7eead1d523ba6"
    sha256 cellar: :any, arm64_linux:       "76f0a75037cbf0e5d8d05686f603a5a081bae92a0105c9ff4b86ea9da79af1ed"
    sha256 cellar: :any, x86_64_linux:      "50ddcd61d0e18ae013d0ef7204a2ea207f00e23b4471d2d4582eca91af011f8c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtquicktimeline"

  resource "rect_rotate.json", :test do
    url "https://raw.githubusercontent.com/qt/qtlottie/888fb0ca5d5e18fe5d8b88ed721544bf204ac158/tests/manual/testApp/rect_rotate.json"
    sha256 "d0d5d2b036c04d4b2c1211d062fe1c123053ea0d4639cd33a2cec724236bf328"
  end

  allow_network_access! :test

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
    ENV["QT_QPA_PLATFORM"] = "minimal"
    system formula_opt_bin("qtdeclarative")/"qml", "test.qml"
  end
end
