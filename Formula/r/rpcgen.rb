class Rpcgen < Formula
  desc "Protocol Compiler"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/developer_cmds/archive/refs/tags/developer_cmds-79.tar.gz"
  sha256 "f44448b61edf1c93fda47a4ce21a47836c633ecb3627d293c820ac099a5cb9b0"
  # Sun-RPC license issue, https://github.com/spdx/license-list-XML/issues/906
  license :cannot_represent

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aa2b37b018f9b8c632f6e96c4ff9634aef1c4ffef6e9c1ac00bd75dab10645b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b59addafc7f3c0fd4787c6f1e3554357824f997e24e40641a2dc2633247c079c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e59264d3f987d9be7c4d3d04c7276415a8799df058a63e5d66d495664ff06e69"
    sha256 cellar: :any_skip_relocation, sonoma:         "1da310e51ec996b0877bec5a0c581b1b1bab5a59fb74f84dc443f3d8c5490206"
    sha256 cellar: :any_skip_relocation, ventura:        "e28fb292cc658a7a9bdb056873e5d1c7402b1928acbf1807f30dd50edadf15ae"
    sha256 cellar: :any_skip_relocation, monterey:       "1ce524e3d98a534ccc5c41d77ba283fe38e3a47bdc759696e6ccb1038af28aea"
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
