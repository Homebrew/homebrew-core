class Qtwebview < Formula
  desc "Displays web content in a QML application"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtwebview-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtwebview-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtwebview-everywhere-src-6.10.2.tar.xz"
  sha256 "7ec406ff0998900ccef0ff8e4e5b1fbf15e4e18f3b43eb72e8b2aeda0dd0eab4"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtwebview.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f535a0b6a3f7acc0a5e0c560f66405abda13ba96ca069665ea16f5a78a0b7636"
    sha256 cellar: :any,                 arm64_sequoia: "1806844888def59d5bf53acb5476a840e93618d07275af3d883dc8b11bb0b399"
    sha256 cellar: :any,                 arm64_sonoma:  "b2a9efdd037a78740fd4cbf3147898c3b397613dee7a6f7565a7b3e68c1d2192"
    sha256 cellar: :any,                 sonoma:        "0f4f9b49977ae160c67359148df70c9e841f36370d1d94d7781e255ed8cd5e85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22fcf8717c8d5570c44eba55ac6d119a854d5860f0fb0a2f68094001da7d68db"
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
