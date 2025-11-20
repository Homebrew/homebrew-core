class Qtquickeffectmaker < Formula
  desc "Tool to create custom Qt Quick shader effects"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtquickeffectmaker-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtquickeffectmaker-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtquickeffectmaker-everywhere-src-6.9.3.tar.xz"
  sha256 "6bf0361d24a0865cba9d94ff169c64cd69ac5d90c85260c29ec84ee5c2a59912"
  license all_of: [
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "BSD-3-Clause", # BlurHelper.qml
  ]
  head "https://code.qt.io/qt/qtquickeffectmaker.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a893524bbe82cdfed488af655dfd5a0c81b8ce5dc6b3ded527c8fd454776a76"
    sha256 cellar: :any,                 arm64_sequoia: "8d1a4e9a7b3b73527846100eca76403824a6dd7d8197f09063dc3f372f2e687d"
    sha256 cellar: :any,                 arm64_sonoma:  "a7bb6d986ce05d5944ff0f1a3d020bf8d33ffcb0be5424789f0082b8039ffd6d"
    sha256 cellar: :any,                 sonoma:        "4c3b005e4a97bb2243b6e7f591c27a4da2f2040c75d0f1e587c63d99b828a19e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56e1b9cd2562345d7aa91f7a6b5f5e4c715f99478815f5f4306b868bcba828fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "978ad9f866e424a5ca384c2cb0c4e0c6269ad2a39893bb5e5a12d23c0788a9e4"
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
