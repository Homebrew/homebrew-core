class Qtvirtualkeyboard < Formula
  desc "Provides an input framework and reference keyboard frontend"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtvirtualkeyboard-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtvirtualkeyboard-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtvirtualkeyboard-everywhere-src-6.12.0.tar.xz"
  sha256 "2aae3628f4648f86959d7853e7e1f50ee96a7f1bb5497afb62b7deff6c350170"
  license all_of: [
    "GPL-3.0-only",
    "Apache-2.0",   # bundled openwnn, pinyin and tcime
    "BSD-3-Clause", # bundled tcime; *.cmake
  ]
  revision 1
  compatibility_version 1
  head "https://code.qt.io/qt/qtvirtualkeyboard.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d929bb281f37dfab1a21e8c2b1fb90787d96650a921fcb372ea1b065b03ad4c0"
    sha256 cellar: :any, arm64_tahoe:       "d345516e638ef95db5464ae5f592ab4b2399d0ef31680363aca2f5dbedc40bea"
    sha256 cellar: :any, arm64_sequoia:     "cf4655ae02da9601d1d93f27f1cb4223de699bc6dda994dfbb0829bb72a1b837"
    sha256 cellar: :any, arm64_linux:       "f8e9841102a710daf95395980aaff668ad5c51b1318ada8247cc01c6cdb57b01"
    sha256 cellar: :any, x86_64_linux:      "18fc455af551f520a2559b2f61a4156df62e6ec1c3a5dc0164bf8e403eb637c7"
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
    ENV["QT_QPA_PLATFORM"] = "minimal"
    system formula_opt_bin("qtdeclarative")/"qml", "test.qml"
  end
end
