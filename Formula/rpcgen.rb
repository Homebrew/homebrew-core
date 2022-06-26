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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78dfb8bb78945458e7800dcc9dec612a7b2d72dcc8f128965c3a62463641526d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e4b76a3f59923370fd526a8d0d7c2d045e24c0fd3bc8a90520a75a0600b2b42"
    sha256 cellar: :any_skip_relocation, monterey:       "614287949fb3eecb3109d34b8d0c8573d2b46ebf63dc1d59bf97fac5ab02942a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8168bcd5de6cb890aae1bd5deb67f732c193f6729606632d7ece185c10dd3b75"
    sha256 cellar: :any_skip_relocation, catalina:       "4d9702a8541f7db461c81f761bd446167473d0b7ad9590370fbbd9cb775442d4"
    sha256 cellar: :any_skip_relocation, mojave:         "6bc4a8c391b448681db323c894b07a57a22a8e4d67015f0b9be7f1cff876d23a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "2a4a7cf95e773ee5a2721cc90832031c6d5bb6dffefd575233acccca0d446631"
  end

  keg_only :provided_by_macos

  depends_on xcode: ["7.3", :build]
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "developer_cmds.xcodeproj",
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
