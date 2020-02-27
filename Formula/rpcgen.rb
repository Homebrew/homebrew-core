class Rpcgen < Formula
  desc "Protocol Compiler"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/developer_cmds/developer_cmds-66.tar.gz"
  sha256 "99d6c4ef4f32593df937a42d50400c17054247e875ab8cfb3bf0f2de19a90860"

  bottle do
    cellar :any_skip_relocation
    sha256 "bff5b2c16c8f161b4828d4f1cd6fe7353b63cb12bec8f4646716199b7f2fb522" => :catalina
    sha256 "e4c588689133af91de553a2a586cdaaebe27fc49c274ae1e2c7c889dc836a327" => :mojave
    sha256 "53ca92eda3bb7eb7f81aa70794ca1b5c16deaba84fe7ad41aaca11f32ebb8988" => :high_sierra
    sha256 "0d3a08d255ccbb538b0e818155e079ff74c65965d6effd67fd74775b837bdddb" => :sierra
    sha256 "75acb2995dda96d42faf6a3f83b1b30c9d0a6502ac1b031f92567282a1c67f69" => :el_capitan
  end

  keg_only :provided_by_macos

  depends_on :xcode => ["7.3", :build]

  def install
    xcodebuild "-project", "developer_cmds.xcodeproj",
               "-target", "rpcgen",
               "-configuration", "Release",
               "SYMROOT=build"
    bin.install "build/Release/rpcgen"
    man1.install "rpcgen/rpcgen.1"
  end

  test do
    assert_match "nettype", shell_output("#{bin}/rpcgen 2>&1", 1)
  end
end
