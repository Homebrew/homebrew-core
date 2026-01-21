class Qtvirtualkeyboard < Formula
  desc "Provides an input framework and reference keyboard frontend"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/qtvirtualkeyboard-everywhere-src-6.10.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/qtvirtualkeyboard-everywhere-src-6.10.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/qtvirtualkeyboard-everywhere-src-6.10.1.tar.xz"
  sha256 "5b9cde3188afbc01b602b9016cee95ccd536aea43a6e6cfd297b44f328b9b6df"
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
    sha256 cellar: :any,                 arm64_tahoe:   "b192e9cc6e68b7a175a76b7abcd98f3dcee3ad86adf2c20c5566ea1442c7bcf6"
    sha256 cellar: :any,                 arm64_sequoia: "988d6e10fbc0e984ef21eec014d3fa02c2c1e604d0d3e4819fd5652fa4116088"
    sha256 cellar: :any,                 arm64_sonoma:  "4f1382264b62f9f318c1648bb6ff6edf9a8fee18b37deed734ecac8441e7096e"
    sha256 cellar: :any,                 sonoma:        "070d4a79d99eff1b10ec3b4670fe51e2fa1a30a82b63117a1274c130b639abf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a66038514839bd21769f2351300f8590079dd139ec70736afabb506df3026de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11d638568dab1aaa0ca2d30a13bbb7659c5ad6ded5a0b647e29801aa39ec62e2"
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
