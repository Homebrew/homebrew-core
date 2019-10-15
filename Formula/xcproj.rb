class Xcproj < Formula
  desc "Manipulate Xcode project files"
  homepage "https://github.com/0xced/xcproj"
  url "https://github.com/0xced/xcproj/archive/0.2.1.tar.gz"
  sha256 "8c31f85d57945cd5bb306d7a0ff7912f2a0d53fa3c888657e0a69ca5d27348cb"
  head "https://github.com/0xced/xcproj.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "46aa93499933dd1599eb4d38ba2e5b8587092c08f8acb691b29a1ccee6a80b17" => :catalina
    sha256 "7efa30f2f581bbcc0962605710b1125965b6b8d13ca8e5fab8517adfe1c9334d" => :mojave
    sha256 "d34b031444c1122392afb789036d3197a0d333ae11447c819509f1f31de30c9f" => :high_sierra
    sha256 "f21fe7b203fbee383f502d66ac8471c7798d74dae7d4ad4491e933fcd1de22d5" => :sierra
    sha256 "c7a6b18a500b28fbd9cba8939423b7a9c480be98e09883ef90e4b605023b451f" => :el_capitan
    sha256 "8e20d277d1927c425544654cd8613765460f0b9bbbb8133b0ac04ebdff5d6f0e" => :yosemite
  end

  depends_on :xcode

  def install
    xcodebuild "-project", "xcproj.xcodeproj",
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
