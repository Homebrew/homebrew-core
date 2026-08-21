class Qtquickeffectmaker < Formula
  desc "Tool to create custom Qt Quick shader effects"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtquickeffectmaker-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtquickeffectmaker-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtquickeffectmaker-everywhere-src-6.11.1.tar.xz"
  sha256 "cfe63e70e88bdd126a175762d3eeb38eb336e45beceedcbd027bc5362744136b"
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
    sha256 cellar: :any,                 arm64_tahoe:   "4bfc9b0e8279512f39bbc4657e6f01ba3fe500cc2d68a1778af868d657732597"
    sha256 cellar: :any,                 arm64_sequoia: "9a9c2b54ed683aefbe2e08a4914dd1d8a75a2738b8016e769c3c8a08e3b07b73"
    sha256 cellar: :any,                 arm64_sonoma:  "284228a5a53138edcc4b90a3375b77a7440a3124eb425d1986834796c31ed717"
    sha256 cellar: :any,                 sonoma:        "6fbf2c2fd85bd0040dac86ffe53d6da38b9cd2a853d1aee6ec5736bf9f0312e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b564300e21269a824fcfeeba8cae336daf9b22a6b58bb3d7ccc5f4c7b1d2b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "153233ca6b17a7f647953452dddad8785956894c8c70276bfe7d3707014843f2"
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
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_match "Qt Quick Effect Maker", shell_output("#{bin}/qqem --help")
  end
end
