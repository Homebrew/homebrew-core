class Qtdeclarative < Formula
  desc "QML, Qt Quick and several related modules"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtdeclarative-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtdeclarative-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtdeclarative-everywhere-src-6.9.3.tar.xz"
  sha256 "5a071b227229afbf5c976b7b59a0d850818d06ae861fcdf6d690351ca3f8a260"
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
