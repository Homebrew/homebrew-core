class Qtwebview < Formula
  desc "Displays web content in a QML application"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtwebview-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtwebview-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtwebview-everywhere-src-6.11.1.tar.xz"
  sha256 "8d62c8ef70d58260e9b3e8b5fc1a8bc48495308a4437003a394483757427133d"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtwebview.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b984232e4807c0b2b0392b70de63c69af350674ee1f5943ede098604572f424d"
    sha256 cellar: :any,                 arm64_sequoia: "c5d8bc46a0491596a01dbe410b19b02588678c34a39bcc80607d5e9f96515506"
    sha256 cellar: :any,                 arm64_sonoma:  "2a65c8eff7f3119a261e6121f9802c5f4c68bf0835157d50d3a3aabd5c0fc145"
    sha256 cellar: :any,                 sonoma:        "e9309c1802f4691da7544ab26393df4be1c2de55f0cfbc45d871ddd1f3804c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d40eb9e5f38687a24dd829072940b8d45582937b6b0e997d25d1c7458a370dd"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtwebengine"

  on_macos do
    depends_on "qtpositioning"
    depends_on "qtwebchannel"
  end

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
      import QtQml
      import QtQuick
      import QtWebView

      Item {
        WebView {
          anchors.fill: parent
          url: "https://brew.sh/"
        }
        Timer {
          interval: 2000
          running: true
          onTriggered: Qt.quit()
        }
      }
    QML

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    system Formula["qtdeclarative"].bin/"qml", "test.qml"
  end
end
