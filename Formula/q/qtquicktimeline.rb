class Qtquicktimeline < Formula
  desc "Enables keyframe-based animations and parameterization"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.2/submodules/qtquicktimeline-everywhere-src-6.11.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.2/submodules/qtquicktimeline-everywhere-src-6.11.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.2/submodules/qtquicktimeline-everywhere-src-6.11.2.tar.xz"
  sha256 "250af10500a0c4045dde74e107448a69a44d58af8b7e9a91704a808d5f881d17"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtquicktimeline.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1d134ff2a31e92d6547bfff86f62b4606be2623f897dd09c4db2b270192e4858"
    sha256 cellar: :any, arm64_tahoe:       "765a34074ca87575b6d09d06743ce55bc4894bf5758ef5d99edbe8601e634b10"
    sha256 cellar: :any, arm64_sequoia:     "e2930f7c7b3afc0080e050cbbd702a852665ce0fbbddbd2dadcb7b0128793351"
    sha256 cellar: :any, arm64_sonoma:      "9881c85b2fd38b1eeea2694c1b178fdf2f2a762de0b0ee7a519d32865e7f4556"
    sha256 cellar: :any, arm64_linux:       "517a2ae9df393569cb24a9e2317119be5317f5176d936aeb6c39bc314b311ad3"
    sha256 cellar: :any, x86_64_linux:      "0b191105863fb4b3a43427ee40cdd75c27cdd3cc9c4a07b345aa12a2320412b8"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "qtbase"
  depends_on "qtdeclarative"

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
      import QtQuick 2.0
      import QtQuick.Timeline 1.0

      Item {
        Timeline {
          id: timeline
          startFrame: 0
          endFrame: 100
          enabled: true
          animations: [
            TimelineAnimation {
              duration: 1000
              from: 0
              to: 100
              running: true
              onRunningChanged: { if(!running) { Qt.quit() } }
            }
          ]
          KeyframeGroup {
            target: rectangle
            property: "color"
            Keyframe { frame: 0; value: "red" }
            Keyframe { frame: 100; value: "blue" }
          }
        }
        Rectangle {
          id: rectangle
          width: 50
          height: 50
          color: "red"
        }
      }
    QML

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal"
    system formula_opt_bin("qtdeclarative")/"qml", "test.qml"
  end
end
