class Qtdeclarative < Formula
  desc "QML, Qt Quick and several related modules"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.2/submodules/qtdeclarative-everywhere-src-6.11.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.2/submodules/qtdeclarative-everywhere-src-6.11.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.2/submodules/qtdeclarative-everywhere-src-6.11.2.tar.xz"
  sha256 "215b7b70517e380123eabc6b92243f3c47b6f016a91d126057dbe53551c6b430"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # qml
    "BSD-2-Clause", # masm
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtdeclarative.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0a0ac2aee0406f79a496b1c9a80c3fc5f66aec0d2fc458d11a4cd0e0bf1c1ed5"
    sha256 cellar: :any, arm64_tahoe:       "5bb514e40e1bf72352604ac4cfbacb532b37c0ba6ab84e405b99a385d1eb4c27"
    sha256 cellar: :any, arm64_sequoia:     "1fe4b9a56a769fafe8baa95d9ad022c68594fcc2f1026d5c7ee079c319d3c35c"
    sha256 cellar: :any, arm64_sonoma:      "80e410e4dfa3423a1b8f4cebb191d5195738bdf79e4478f1b342d0257230f49f"
    sha256 cellar: :any, arm64_linux:       "8dc3a256247d767407b7e9dcd187d357862e3f55d714f3413bfdf3a4b3267f4f"
    sha256 cellar: :any, x86_64_linux:      "24690731582b68d8000f06fef3573b38e91198f42aeb00277791758bb53310fc"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "qtlanguageserver" => :build
  depends_on "qtshadertools" => :build
  depends_on "vulkan-headers" => :build

  depends_on "qtbase"
  depends_on "qtsvg"

  uses_from_macos "python" => :build

  conflicts_with "qt@5", because: "both link conflicting binaries"

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return unless OS.mac?

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework")

    # Remove non-executable file used for signing app
    rm(bin/"qml.entitlements")
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
