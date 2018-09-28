class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/0.3.5.tar.gz"
  sha256 "100df971e106709b07046a16917ae8b052eb1e250ecab305fe65c8d0a50141ef"
  head "https://github.com/facebook/xctool.git"

  bottle do
    cellar :any
    sha256 "5ae94ec75e7d99216d1813fa1ee3a8912da3b4acace28969be3ba33ebaa4a162" => :high_sierra
    sha256 "cd4e7895c40b15d12c5e55d206a29e88b22e5a8dea6107a25b50234fe1710ff0" => :sierra
    sha256 "cfd03ef1008a4a01b923e72fb7e79209d021d88ffe8bb89ac22307ba6af0cce0" => :el_capitan
  end

  depends_on :xcode => "7.0"

  def install
    xcodebuild "-workspace", "xctool.xcworkspace",
               "-scheme", "xctool",
               "-configuration", "Release",
               "SYMROOT=build",
               "-IDEBuildLocationStyle=Custom",
               "-IDECustomDerivedDataLocation=#{buildpath}",
               "XT_INSTALL_ROOT=#{libexec}"
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
