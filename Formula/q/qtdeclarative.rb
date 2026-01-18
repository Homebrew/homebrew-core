class Qtdeclarative < Formula
  desc "QML, Qt Quick and several related modules"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/qtdeclarative-everywhere-src-6.10.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/qtdeclarative-everywhere-src-6.10.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/qtdeclarative-everywhere-src-6.10.1.tar.xz"
  sha256 "4fb4efb894e0b96288543505d69794d684bcfbe4940ce181d3e6817bda54843e"
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
    sha256                               arm64_tahoe:   "f5d3ad183dac48d04969ba00442907ad703455fe318f29d53a358f2e7e4e4848"
    sha256                               arm64_sequoia: "c1c1a24a13c2aded189ff67708581af6876689d59a1d4e439513b6abbcd83b14"
    sha256                               arm64_sonoma:  "c0fa5b66c536622aa8e4cd437fc5489114ff40a01a4137de7ce952203dcf6962"
    sha256 cellar: :any,                 sonoma:        "b45e9bba085f9f9ed48e47ac935d3e4709c448bda63c5ccf0b083177e3c2dc11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4849569e69b7a22af43f8d104de9b81b8f340fc3af95922a80289cba34e68e65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f589c355af3d618e5cbaafa16fb9ebdde0f4ec11ce44a8a3aab6a622d969dc81"
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
