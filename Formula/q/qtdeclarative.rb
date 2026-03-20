class Qtdeclarative < Formula
  desc "QML, Qt Quick and several related modules"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtdeclarative-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtdeclarative-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtdeclarative-everywhere-src-6.10.2.tar.xz"
  sha256 "a249914ff66cdcdbf0df8b5ffad997a2ee6dce01cc17d43c6cc56fdc1d0f4b0f"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # qml
    "BSD-2-Clause", # masm
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtdeclarative.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256                               arm64_tahoe:   "40c4fa0ae02ea69c6bddfc2ed6e184638c59843e6ccc23d89ca5fb0d020db793"
    sha256                               arm64_sequoia: "43ec33cc1424f501c43cbde74bbbe592d6d083f7311ed462c51d90cd93a23217"
    sha256                               arm64_sonoma:  "470efa5dddc0cbf8663965f4538dd25ae25444c7f8f679ea2570c06ee6890d3d"
    sha256 cellar: :any,                 sonoma:        "826cdedf5cf1d7180bec128312b7a1ab708228cbff94b21d4a5f204561373d93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cb7ddd01b559c5b2fd499c20ee01b2c62f7041934d9a36317dbba4373b5236f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "412bad1588deeefae1fb0ba898d387cc3155b3656791e5285930e95be0a47c42"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "qtlanguageserver" => :build
  depends_on "qtshadertools" => :build
  depends_on "vulkan-headers" => :build

  depends_on "qtbase"
  depends_on "qtsvg"

  uses_from_macos "python" => :build

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
    # https://github.com/qt/qtdeclarative/blob/dev/tests/auto/qml/qqmlapplicationengine/testapp/immediateQuit.qml
    (testpath/"immediateQuit.qml").write <<~QML
      import QtQml
      import QtQuick
      QtObject {
        Component.onCompleted: {
          console.log("End: " + Qt.application.arguments[1]);
          Qt.quit()
        }
      }
    QML

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux?
    assert_match "qml: End: immediateQuit.qml", shell_output("#{bin}/qml immediateQuit.qml 2>&1")
  end
end
