class Rpcgen < Formula
  desc "Protocol Compiler"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/developer_cmds/developer_cmds-66.tar.gz"
  sha256 "99d6c4ef4f32593df937a42d50400c17054247e875ab8cfb3bf0f2de19a90860"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d9702a8541f7db461c81f761bd446167473d0b7ad9590370fbbd9cb775442d4" => :catalina
    sha256 "6bc4a8c391b448681db323c894b07a57a22a8e4d67015f0b9be7f1cff876d23a" => :mojave
    sha256 "2a4a7cf95e773ee5a2721cc90832031c6d5bb6dffefd575233acccca0d446631" => :high_sierra
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
