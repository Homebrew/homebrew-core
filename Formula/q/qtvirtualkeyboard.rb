class Qtvirtualkeyboard < Formula
  desc "Provides an input framework and reference keyboard frontend"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtvirtualkeyboard-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtvirtualkeyboard-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtvirtualkeyboard-everywhere-src-6.10.2.tar.xz"
  sha256 "6273256091a83f3f283d1a91498964fd6a91256b667d7b9e98005d731fdb986b"
  license all_of: [
    "GPL-3.0-only",
    "Apache-2.0",   # bundled openwnn, pinyin and tcime
    "BSD-3-Clause", # bundled tcime; *.cmake
  ]
  head "https://code.qt.io/qt/qtvirtualkeyboard.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a7e5167b0864b4f73b22bb6230f36821cfb706c03d7711d5ad3b434481cb432"
    sha256 cellar: :any,                 arm64_sequoia: "e15c90b5c7eeb99390b3ce26186a8d31b45ecb0ebad785f9217898882ca293c4"
    sha256 cellar: :any,                 arm64_sonoma:  "d516b9d77f0f837099f41b5f073a15a289a5beeba664ed56f94f523a01e7576c"
    sha256 cellar: :any,                 sonoma:        "9c513779a92a3bf71472c271523279a3b0205821c3168e3e50e04e9e5da7b09d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "314575dfccf4459fc27e0283508bbe4f5e580280fa90d3c33f9e35797c479cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "341a55605760887b021f35204b33a7b3fcc2edcd1c742131db602bdaa5dc526b"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "hunspell"
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtmultimedia"
  depends_on "qtsvg"

  def install
    rm_r("src/plugins/hunspell/3rdparty/hunspell")

    args = %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DFEATURE_system_hunspell=ON
    ]
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
      import QtQuick
      import QtQuick.Window
      import QtQuick.VirtualKeyboard

      Window {
        visible: true
        width: 640
        height: 480
        id: root

        InputPanel {
          id: inputPanel
          anchors.bottom: parent.bottom
          width: root.width
        }
        Timer {
          interval: 2000
          running: true
          onTriggered: Qt.quit()
        }
      }
    QML

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux?
    system Formula["qtdeclarative"].bin/"qml", "test.qml"
  end
end
