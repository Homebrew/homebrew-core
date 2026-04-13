class Qtvirtualkeyboard < Formula
  desc "Provides an input framework and reference keyboard frontend"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.0/submodules/qtvirtualkeyboard-everywhere-src-6.11.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.0/submodules/qtvirtualkeyboard-everywhere-src-6.11.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.0/submodules/qtvirtualkeyboard-everywhere-src-6.11.0.tar.xz"
  sha256 "d88a4b1713a313e3ac06c32837b5d00724d1dcf7b44c2594f1029f7c74a8e686"
  license all_of: [
    "GPL-3.0-only",
    "Apache-2.0",   # bundled openwnn, pinyin and tcime
    "BSD-3-Clause", # bundled tcime; *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtvirtualkeyboard.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "85d54ee498d6a1dccd74b7c621e59be0e1b96b390f5d2f4c276512da5f9f2555"
    sha256 cellar: :any,                 arm64_sequoia: "406ba562e2bc0909368513f508fa063f0d446343f76cb10fb9bdb74ac601819c"
    sha256 cellar: :any,                 arm64_sonoma:  "7787419d7ddc8bc629c559b7c1561203b9aab9c722d0b9a2b40950071d5d558b"
    sha256 cellar: :any,                 sonoma:        "a60c2edaebe98b7d096aa9328457228bb07465af9c6dba605afc0e711be22236"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f28d48c5d031753769766edb997cdc27b46cdca78813d94abc807beb2e3ec80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40a48084da7320176855e46781716c6cec3cecf60af60f28d37814f47ce1e938"
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
