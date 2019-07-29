class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/0.3.6.tar.gz"
  sha256 "9c9135b2d447134c706c6dbdb8dfa6af148e8aa01811f14e92861b5825578b55"
  head "https://github.com/facebook/xctool.git"

  bottle do
    cellar :any
    sha256 "80fd9400d09b4263c403752c171dc6bb512a85121bcf15d71e5bf0a1f8edd884" => :mojave
    sha256 "6a49ea600c94ef2c294966b5d921266eeeea0f7e36d0dcefc187233a4681b36e" => :high_sierra
    sha256 "3af550733cfaa53e47402bf6153a1a4d711f4b0b4ed80009bd1548c41ae25fbc" => :sierra
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
