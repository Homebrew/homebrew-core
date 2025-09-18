class Telnet < Formula
  desc "User interface to the TELNET protocol"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/remote_cmds/archive/refs/tags/remote_cmds-306.tar.gz"
  sha256 "7f014f7eebb115460ea782e6bcade6d16effa56da17ee30f00012af07bc96c36"
  license all_of: ["BSD-4-Clause-UC", "APSL-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6916778f3b7f0607f648eba463764b8aaf9249daa4d6f12f3f2c2891c925059a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5314fd7135b21e32772b3d96751829e521453a429ab6b734fefbc99b4c94446"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4db0190453f42c13370d8412c5d15398c1f85528c2f55e0e7f70d87d6fe1fd19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19ac3a5684b7216a9f42b0d38574fe09b675060184a703b9ce902778080b45e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cd17dbe54ca38974677ffaa5716384f0095957f5ad6aa5ee6e6398f58de6cb9"
    sha256 cellar: :any_skip_relocation, ventura:       "e19e94a0f40871798ad05efa016f6bfd367b6216e3230d87324d41437411562a"
  end

  depends_on xcode: :build
  depends_on :macos

  conflicts_with "inetutils", because: "both install 'telnet' binaries"

  resource "libtelnet" do
    url "https://github.com/apple-oss-distributions/libtelnet/archive/refs/tags/libtelnet-13.tar.gz"
    sha256 "4ffc494a069257477c3a02769a395da8f72f5c26218a02b9ea73fa2a63216cee"
  end

  def install
    resource("libtelnet").stage do
      ENV["SDKROOT"] = MacOS.sdk_path
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      xcodebuild "OBJROOT=build/Intermediates",
                 "SYMROOT=build/Products",
                 "DSTROOT=build/Archive",
                 "-IDEBuildLocationStyle=Custom",
                 "-IDECustomDerivedDataLocation=#{buildpath}",
                 "-arch", Hardware::CPU.arch

      libtelnet_dst = buildpath/"libtelnet"
      libtelnet_dst.install "build/Products/Release/libtelnet.a"
      libtelnet_dst.install "build/Products/Release/usr/local/include/libtelnet/"
    end

    xcodebuild "OBJROOT=build/Intermediates",
               "SYMROOT=build/Products",
               "DSTROOT=build/Archive",
               "OTHER_CFLAGS=${inherited} #{ENV.cflags} -I#{buildpath}/libtelnet",
               "OTHER_LDFLAGS=${inherited} #{ENV.ldflags} -L#{buildpath}/libtelnet",
               "-IDEBuildLocationStyle=Custom",
               "-IDECustomDerivedDataLocation=#{buildpath}",
               "-sdk", "macosx",
               "-arch", Hardware::CPU.arch,
               "-target", "telnet"

    bin.install "build/Products/Release/telnet"
    man1.install "telnet/telnet.1"
  end

  test do
    output = shell_output("#{bin}/telnet india.colorado.edu 13", 1)
    assert_match "Connected to india.colorado.edu.", output
  end
end
