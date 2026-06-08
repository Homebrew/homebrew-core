class Qtdeclarative < Formula
  desc "QML, Qt Quick and several related modules"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtdeclarative-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtdeclarative-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtdeclarative-everywhere-src-6.11.1.tar.xz"
  sha256 "52e670f670b0304f534b24f98c47ceb8a41bb710464414ebc9527ec71cc86aa4"
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
    sha256                               arm64_tahoe:   "aacbb6dcaeea70c2c3bd94cd1202791245d8c66cd9bccc23f3d8913f73a8b8ae"
    sha256                               arm64_sequoia: "7cada376381dc2bba18264b2d9bca1b12e8fb8bebc1e69ace43ced2370f97f9d"
    sha256                               arm64_sonoma:  "aa854c691cef234dd1311d41b7f8de836628ffe9cfac080e884a5ad81e6e8d0c"
    sha256 cellar: :any,                 sonoma:        "91ac1b7584bd5022e5d0cdcc8b894ad5b88ad68af543cd9d142086bb61db1423"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b104ba8a9ad0da5730305d4bbef270e0150f933fe83c9c92757c9e9a0ca8619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d24bca1c690df08841efbae429b895941b587e807903e879774a178a9e279cac"
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
