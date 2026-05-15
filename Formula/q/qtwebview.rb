class Qtwebview < Formula
  desc "Displays web content in a QML application"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.0/submodules/qtwebview-everywhere-src-6.11.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.0/submodules/qtwebview-everywhere-src-6.11.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.0/submodules/qtwebview-everywhere-src-6.11.0.tar.xz"
  sha256 "cb0eaed94a12d5f650863d346c423e9f4383dbce1d05866869c40118c6e8c4b3"
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
    sha256 cellar: :any,                 arm64_tahoe:   "41052efd041cb2e013ee13a5dc5f51a6be4394d5e7dcbe8e8de4e8ba9b4faabd"
    sha256 cellar: :any,                 arm64_sequoia: "8585eb79ee20e4c4bc4462b111ed962a44d19989a9f04a85982a0e0d6361e126"
    sha256 cellar: :any,                 arm64_sonoma:  "ff5b84d3a0d86a6d8e14468827bb8ba364336e100e16fc812a5ed95498a933df"
    sha256 cellar: :any,                 sonoma:        "7e893151bbb90939bf14f7aaeea5a7f5386f8ad2d089d421c03577d30a86284a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38ee0420ddc45b43263fa2a7f9eadf5c0f734358af15c3a9ce4a170889def5b1"
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
