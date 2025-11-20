class Qtvirtualkeyboard < Formula
  desc "Provides an input framework and reference keyboard frontend"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtvirtualkeyboard-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtvirtualkeyboard-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtvirtualkeyboard-everywhere-src-6.9.3.tar.xz"
  sha256 "a1a0d5c91c9e7fe608867718c152272feae8560d920effa59c2c84b6dd415534"
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
    sha256 cellar: :any,                 arm64_tahoe:   "78a84f372e813098650d43337913bf4112c3420136d4b64767cb5968fae8878c"
    sha256 cellar: :any,                 arm64_sequoia: "ea7625eabe9a4c93c1866da81e1ba50bae0297c6e03b5f95f14fd7522b98d1e0"
    sha256 cellar: :any,                 arm64_sonoma:  "2010c623e221e4c520775236e7eedfe42e5cabba2434a5b5525073aa9b13e1b4"
    sha256 cellar: :any,                 sonoma:        "460f1745bcb772f68336ac4e6ff43a328a6628db1b2fc7ce1c5c5d28a5cd0af5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ab62e97585753a9c834b12f2078add9d4e73fb46e5082cc9fabb9bb7e2f7573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "752a918558c0469dadfee3a461ae4c61bd833a68280d8c50bd3f1ed5c168ddb2"
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
