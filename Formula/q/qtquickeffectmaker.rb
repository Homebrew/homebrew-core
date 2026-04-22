class Qtquickeffectmaker < Formula
  desc "Tool to create custom Qt Quick shader effects"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.0/submodules/qtquickeffectmaker-everywhere-src-6.11.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.0/submodules/qtquickeffectmaker-everywhere-src-6.11.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.0/submodules/qtquickeffectmaker-everywhere-src-6.11.0.tar.xz"
  sha256 "ac02813fee62de71b8857fdab51cc20f752ebbefba80fe0ea7a2d77c12d9d715"
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
    sha256 cellar: :any,                 arm64_tahoe:   "5a5f0b3dbb30fc5f69d3664a00486a34165a6bca85a81cdedd5e86e2277e3683"
    sha256 cellar: :any,                 arm64_sequoia: "5f64879adeff197bf46967f7de4cf96b5d4da0f27d4a789670d80b7520995d28"
    sha256 cellar: :any,                 arm64_sonoma:  "8a6d7b9c1f465ff1dcf2e9791f4df1503723e2afe003f52dd0e45366bfb8edaa"
    sha256 cellar: :any,                 sonoma:        "5ffeb8b51854b6c8be1be8013b67ed80987a378de0ecbfe640b9353975bc19c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d382fccde57145db70860913d77661210f9f0eb4a254884160d9fc60834bf5eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6729291906099ca167376b4543bc08c873a979ccbe944393e88645dd61d0e91"
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
