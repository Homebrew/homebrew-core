class Qtwebview < Formula
  desc "Displays web content in a QML application"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.2/submodules/qtwebview-everywhere-src-6.11.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.2/submodules/qtwebview-everywhere-src-6.11.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.2/submodules/qtwebview-everywhere-src-6.11.2.tar.xz"
  sha256 "7e21e109ee89dadeef2d3edd786bcb9d64a5562ea546f89dcc79b3f52f881f4c"
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
    sha256 cellar: :any, arm64_golden_gate: "c8673882004045b44eccfbf14b9d01c6b3d6c175c0ced43eb348d7ff61889fbc"
    sha256 cellar: :any, arm64_tahoe:       "885ca728bade5ac4ff77e16214702710304b2633d925aa39df8baa50a15b9563"
    sha256 cellar: :any, arm64_sequoia:     "92180c71643e8d69a2f03d42bc7a538652abbdb1bf37efdcf5c0924d66b19e48"
    sha256 cellar: :any, arm64_sonoma:      "3dcb03116185af260b362bd89beb2e6754af8f1afe90e43de432ff0f293a0278"
    sha256 cellar: :any, arm64_linux:       "65f470201641db39394ccc2c4504fe249784feb92cbe56b04be883bac739bbfd"
    sha256 cellar: :any, x86_64_linux:      "1013154bf62a2c0f087a0a2e0b2d49466fb10530fab623460dfbaa573980fa44"
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
    ENV["QT_QPA_PLATFORM"] = "minimal"
    system formula_opt_bin("qtdeclarative")/"qml", "test.qml"
  end
end
