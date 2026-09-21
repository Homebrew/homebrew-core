class Qtquickeffectmaker < Formula
  desc "Tool to create custom Qt Quick shader effects"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.2/submodules/qtquickeffectmaker-everywhere-src-6.11.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.2/submodules/qtquickeffectmaker-everywhere-src-6.11.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.2/submodules/qtquickeffectmaker-everywhere-src-6.11.2.tar.xz"
  sha256 "7923dc7284e933a5e36ae24a427564f04e0b27af8dfa38eee8092c01c2835cb7"
  license all_of: [
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "BSD-3-Clause", # BlurHelper.qml
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtquickeffectmaker.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b4a8f7b0d7f852ca54a3a58dbf105051d18d340893d9d34228d6568ae8605f89"
    sha256 cellar: :any, arm64_tahoe:       "288817f8a66f41eb5423f51289f362db89cb71853cbf7e8f0d6af1073effa57f"
    sha256 cellar: :any, arm64_sequoia:     "7489be83a2c6e8694a9047a39b34b3ca204be82eb1ba8b5f8882c5b38e00e707"
    sha256 cellar: :any, arm64_sonoma:      "3e4270cd70792ea185f490a8836ad11e66e11047c62cc720dee7a8f0d75d24c4"
    sha256 cellar: :any, arm64_linux:       "928b4d079f08e96bffc681305466a297884e32c46e3ea94c94f4640046b33048"
    sha256 cellar: :any, x86_64_linux:      "0400bd1a31f0b37ebe22250b40a00da201449ed86d3da530fe500ed3d3fdd5ef"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtquick3d"
  depends_on "qtshadertools"

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

    bin.glob("*.app") do |app|
      libexec.install app
      bin.write_exec_script libexec/app.basename/"Contents/MacOS"/app.stem
    end
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "minimal"
    assert_match "Qt Quick Effect Maker", shell_output("#{bin}/qqem --help")
  end
end
