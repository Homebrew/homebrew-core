class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/0.3.5.tar.gz"
  sha256 "100df971e106709b07046a16917ae8b052eb1e250ecab305fe65c8d0a50141ef"
  head "https://github.com/facebook/xctool.git"

  bottle do
    cellar :any
    sha256 "b2693944c691e1ae53a14bd3b3cae22432a763d42d5cc84ce7487439f1de53fa" => :mojave
    sha256 "b7f05ca2bc15cbdc6f715bc8e53774c9faa3c7c21ffe91a1a8d4e78101f3634c" => :high_sierra
    sha256 "193c2940c85153bfffed60c0f572f3fa26ee6e7e4781d8c0e3b477a0a9bd2f80" => :sierra
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
