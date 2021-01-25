class Rpcgen < Formula
  desc "Protocol Compiler"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/developer_cmds/developer_cmds-66.tar.gz"
  sha256 "99d6c4ef4f32593df937a42d50400c17054247e875ab8cfb3bf0f2de19a90860"
  # Sun-RPC license issue, https://github.com/spdx/license-list-XML/issues/906

  livecheck do
    url "https://opensource.apple.com/tarballs/developer_cmds/"
    regex(/href=.*?developer_cmds[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8168bcd5de6cb890aae1bd5deb67f732c193f6729606632d7ece185c10dd3b75" => :big_sur
    sha256 "9e4b76a3f59923370fd526a8d0d7c2d045e24c0fd3bc8a90520a75a0600b2b42" => :arm64_big_sur
    sha256 "4d9702a8541f7db461c81f761bd446167473d0b7ad9590370fbbd9cb775442d4" => :catalina
    sha256 "6bc4a8c391b448681db323c894b07a57a22a8e4d67015f0b9be7f1cff876d23a" => :mojave
    sha256 "2a4a7cf95e773ee5a2721cc90832031c6d5bb6dffefd575233acccca0d446631" => :high_sierra
  end

  keg_only :provided_by_macos

  depends_on xcode: ["7.3", :build]

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
