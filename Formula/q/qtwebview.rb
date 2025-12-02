class Qtwebview < Formula
  desc "Displays web content in a QML application"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtwebview-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtwebview-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtwebview-everywhere-src-6.9.3.tar.xz"
  sha256 "c65e1fc0b1f1cb80ac05577059d2c294256761ab0686d569ca88010c85c42cc8"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtwebview.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4d52e628774a62aa29e98f9009379983ea83368d0e77c3e99b56e6b6f1c0fedc"
    sha256 cellar: :any,                 arm64_sequoia: "1072fc879e5334907231e52b4e44a19a5b3987a43c1772ca45f9789a5d09a103"
    sha256 cellar: :any,                 arm64_sonoma:  "5c11fbaba791f6ff23ce41077739a44efd440b46ee12e37ec99b9d5502afaba0"
    sha256 cellar: :any,                 sonoma:        "3b1d771cdd26b94632867a14fcb81b237ed4623ac11e716ce0ef9a6cf14d37e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fd896feb109232e1871f3b4fdb259ec86c7f5f93e1502ee7566ec3a52fb8bcd"
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
