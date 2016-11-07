class Xcproj < Formula
  desc "Manipulate Xcode project files"
  homepage "https://github.com/0xced/xcproj"
  url "https://github.com/0xced/xcproj/archive/0.2.1.tar.gz"
  sha256 "8c31f85d57945cd5bb306d7a0ff7912f2a0d53fa3c888657e0a69ca5d27348cb"

  head "https://github.com/0xced/xcproj.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cec2f112fb12dde22497fec74391856ee22444a5d7b9ea8bde704c35c3b837d" => :sierra
    sha256 "238eb433842ac6622685054b051e93ba1fef14a587a88b134e4257134931e4af" => :el_capitan
    sha256 "2aa9ad13307fcaa90ea2c98789764f2441c8610cfdba3266a2e305bb0e00f77d" => :yosemite
    sha256 "64c9bef0c410c6494f0677e34023b75657be4b35e85e13468e9c0cb20c377c09" => :mavericks
  end

  depends_on :macos => :mountain_lion
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
    <<-EOS.undent
      The xcproj binary is bound to the Xcode version that compiled it. If you delete, move or
      rename the Xcode version that compiled the binary, xcproj will fail with the following error:

          DVTFoundation.framework not found. It probably means that you have deleted, moved or
          renamed the Xcode copy that compiled `xcproj`.
          Simply recompiling `xcproj` should fix this problem.

      In which case you will have to remove and rebuild the installed xcproj version.
    EOS
  end
end
