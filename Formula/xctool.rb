class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/0.3.4.tar.gz"
  sha256 "e760d6e846f9547487b4238391debf3bfc11e5a41f7bb9a1dafb9d51b1d99295"
  head "https://github.com/facebook/xctool.git"

  bottle do
    cellar :any
    sha256 "5ae94ec75e7d99216d1813fa1ee3a8912da3b4acace28969be3ba33ebaa4a162" => :high_sierra
    sha256 "cd4e7895c40b15d12c5e55d206a29e88b22e5a8dea6107a25b50234fe1710ff0" => :sierra
    sha256 "cfd03ef1008a4a01b923e72fb7e79209d021d88ffe8bb89ac22307ba6af0cce0" => :el_capitan
  end

  depends_on :xcode => "7.0"

  def install
    system "./scripts/build.sh", "XT_INSTALL_ROOT=#{libexec}", "-IDECustomDerivedDataLocation=#{buildpath}"
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
