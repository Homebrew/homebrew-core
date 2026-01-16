class Qtquickeffectmaker < Formula
  desc "Tool to create custom Qt Quick shader effects"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/qtquickeffectmaker-everywhere-src-6.10.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/qtquickeffectmaker-everywhere-src-6.10.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/qtquickeffectmaker-everywhere-src-6.10.1.tar.xz"
  sha256 "3036984cc55054f59c4a7c7d30d9b9a2dd7491344b3201c5a133cc3cdf12acc9"
  license all_of: [
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "BSD-3-Clause", # BlurHelper.qml
  ]
  head "https://code.qt.io/qt/qtquickeffectmaker.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ae990aad2d946d6774adaacad51cca2ab878dd39ae8c8abe00c4aec8131c0a93"
    sha256 cellar: :any,                 arm64_sequoia: "7a5ca70ad2bc43732018d78d9e01db901c8e4983c2dcb2da4d1305160782ff50"
    sha256 cellar: :any,                 arm64_sonoma:  "e36f5ece22179473907c597dbcf7f93cf52d77522015f00918c8114c2bfbd882"
    sha256 cellar: :any,                 sonoma:        "d5b60d1e3ce15c6aca823c6f0009d9f035cbd6ada2ec0cd223278cd46806dd4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8948cfcf8732e051ab5d90926e7ab3d699c5ddf2811525b1310343528044068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "076aabafc200d6b8265a7ae146e986b5940f3f7cd232793db1be78941897f611"
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
