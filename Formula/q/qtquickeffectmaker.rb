class Qtquickeffectmaker < Formula
  desc "Tool to create custom Qt Quick shader effects"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtquickeffectmaker-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtquickeffectmaker-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtquickeffectmaker-everywhere-src-6.10.2.tar.xz"
  sha256 "e3caf13b4e0c0d9e6d696192137615e8e748d7999272c74472945067f469c2c4"
  license all_of: [
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "BSD-3-Clause", # BlurHelper.qml
  ]
  head "https://code.qt.io/qt/qtquickeffectmaker.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "85bf5c0809f576eda9725ebe8e51b47589df1a7dfa104e634ad314095632177d"
    sha256 cellar: :any,                 arm64_sequoia: "6cec25062200ed0b41fee16ca2ef59aa5a92b58bd9ea8532f0b58cc92a102837"
    sha256 cellar: :any,                 arm64_sonoma:  "5d31fbaa5bed2cbfa1909db5fcb03ac7f84c985f2ce1347f781f8f308de3d76f"
    sha256 cellar: :any,                 sonoma:        "c3ac2d7ef191e4a9ab083ae13ec74ed3e1e77da8981f8c6f27598c5baa76af0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adecbfcf2e4ce8cfea6baa635c4181429f5cdb5214e2866b37319622741bb560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61761c5fd99ffe4848f792031d42c48d3332225824b6719f77e29d8dee2c10e6"
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
