class Rpcgen < Formula
  desc "Protocol Compiler"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/developer_cmds/archive/refs/tags/developer_cmds-68.tar.gz"
  sha256 "6f9e01612453ea37b8af384e1160e13215ecbdc2c2bd8631e3b872219ab1a0f0"
  # Sun-RPC license issue, https://github.com/spdx/license-list-XML/issues/906

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "632f111183949b67cdd6ae0d09dcd163456dbc8ac3c404b2d7b357b3f64ee869"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b826f320d3f8cf37b7a4d5ac2ab65f31672af8a1114f99ddac98c8ac70b9b2f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52f4353e3908706487141b09bdc5e30c24fddf1189c819dfbba09e810d2f50af"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2c65967becdac24363421d8a162f8a41de3914d148b9b17921a366626f01e89"
    sha256 cellar: :any_skip_relocation, ventura:        "5f2fe33def023209592904ededfe4dab17fb97ee251aaab96440473195d1d4b0"
    sha256 cellar: :any_skip_relocation, monterey:       "ba85e2a510a78d09e64b8d2cf051ffaa8eeee41e851e22ab0cc2a2953faa3e4a"
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
