class Qtwebview < Formula
  desc "Displays web content in a QML application"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtwebview-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtwebview-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtwebview-everywhere-src-6.12.0.tar.xz"
  sha256 "bee0642225614d7fc9486a2ca6db7d2c82a28c311404d1503185a360792c504e"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  revision 1
  compatibility_version 1
  head "https://code.qt.io/qt/qtwebview.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7306cdfd14f09e86ccd6a591ccc421de2fe571046f991c9aca2f61cc13164d53"
    sha256 cellar: :any, arm64_tahoe:       "8cbc8b44707b0bf28e8869325b223718463651737491773af18b9426b84a2bbe"
    sha256 cellar: :any, arm64_sequoia:     "db07ff8f985dd4faa817eb7782cbdc7e24fdb38130e7e4a860725ad5544069fb"
    sha256 cellar: :any, arm64_linux:       "112da0c9ed24d8f3f480f07a6761eb1190e8818c12b3787011b3917b33867bac"
    sha256 cellar: :any, x86_64_linux:      "17e445b09ad3ecf32a3af3200bce39a74979b80fc2e1900387c00644830ab2c4"
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

  allow_network_access! :test

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?
    args << "-DQT_NO_PACKAGE_VERSION_CHECK=TRUE" # TODO: remove once QtWebEngine 6.140.0 is available

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
