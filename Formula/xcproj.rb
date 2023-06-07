class Xcproj < Formula
  desc "Manipulate Xcode project files"
  homepage "https://github.com/0xced/xcproj"
  url "https://github.com/0xced/xcproj/archive/0.2.1.tar.gz"
  sha256 "8c31f85d57945cd5bb306d7a0ff7912f2a0d53fa3c888657e0a69ca5d27348cb"
  head "https://github.com/0xced/xcproj.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2aa49c796bf690ccae0869b3a1f0d58b733499a67972461b52bdf5c307e096be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aa6cbe2067d6430fd54edb655b431e1e066f8e98f98b7001a09272082b5376c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3a9073db30a288af4d7fd2aa2adbc91f93ea6bc8cc9e7e85e0cf4d12dac3716"
    sha256 cellar: :any_skip_relocation, ventura:        "5d73e10bc8b36033ba5e1f9a92cf9d556b14704f3aa29ec05e68de611b9f520a"
    sha256 cellar: :any_skip_relocation, monterey:       "46c8736137abdd261d6c1f5b3bbc25da4a53ec62e4ed135732e952a47d2ca718"
    sha256 cellar: :any_skip_relocation, big_sur:        "e153fbfaf308d9fa35f228a0ad5ab4f1fbbbac9f7040eb0fc1ace90ba9541b7c"
    sha256 cellar: :any_skip_relocation, catalina:       "46aa93499933dd1599eb4d38ba2e5b8587092c08f8acb691b29a1ccee6a80b17"
    sha256 cellar: :any_skip_relocation, mojave:         "7efa30f2f581bbcc0962605710b1125965b6b8d13ca8e5fab8517adfe1c9334d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d34b031444c1122392afb789036d3197a0d333ae11447c819509f1f31de30c9f"
    sha256 cellar: :any_skip_relocation, sierra:         "f21fe7b203fbee383f502d66ac8471c7798d74dae7d4ad4491e933fcd1de22d5"
    sha256 cellar: :any_skip_relocation, el_capitan:     "c7a6b18a500b28fbd9cba8939423b7a9c480be98e09883ef90e4b605023b451f"
  end

  # upstream issue tracker for license
  # https://github.com/0xced/xcproj/issues/6
  deprecate! date: "2022-12-03", because: "no license for the project"

  depends_on :macos
  depends_on :xcode

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "xcproj.xcodeproj",
               "-scheme", "xcproj",
               "SYMROOT=build",
               "DSTROOT=#{prefix}",
               "INSTALL_PATH=/bin",
               "-verbose",
               "install"
  end

  def caveats
    <<~EOS
      The xcproj binary is bound to the Xcode version that compiled it. If you delete, move or
      rename the Xcode version that compiled the binary, xcproj will fail with the following error:

          DVTFoundation.framework not found. It probably means that you have deleted, moved or
          renamed the Xcode copy that compiled `xcproj`.
          Simply recompiling `xcproj` should fix this problem.

      In which case you will have to remove and rebuild the installed xcproj version.
    EOS
  end

  test do
    system "#{bin}/xcproj", "--version"
  end
end
