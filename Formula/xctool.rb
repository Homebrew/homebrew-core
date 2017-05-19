class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/0.3.1.tar.gz"
  sha256 "9db246a95af6716cca93a57b45905c97b3228c1167b4ae7c9461715cfb3e9df0"
  head "https://github.com/facebook/xctool.git"

  bottle do
    cellar :any
    sha256 "7df0210ebb932eba903a68aa3b7618d15e0152c554b1730186323d70f077c6b0" => :sierra
    sha256 "7e773b2754bb89dc576dd292e9c478777bd97771f8d2d1827686b6674d5dc155" => :el_capitan
    sha256 "7704c484b555e0f5143fc61b69cc2b03ff96942e7d0e4e374ac78065eca8f544" => :yosemite
  end

  depends_on :xcode => "7.0"

  def install
    system "./scripts/build.sh", "SYMROOT=build", "XT_INSTALL_ROOT=#{libexec}", "-IDECustomDerivedDataLocation=#{buildpath}"
    bin.install_symlink "#{libexec}/bin/xctool"
  end

  def post_install
    # all libraries need to be signed to avoid codesign errors when
    # injecting them into xcodebuild or Simulator.app.
    Dir.glob("#{libexec}/lib/*.dylib") do |lib_file|
      system "/usr/bin/codesign", "-f", "-s", "-", lib_file
    end
  end

  test do
    system "(#{bin}/xctool -help; true)"
  end
end
