class Telnet < Formula
  desc "User interface to the TELNET protocol"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/remote_cmds/archive/refs/tags/remote_cmds-303.141.1.tar.gz"
  sha256 "5b434a619008406a798af1d724591f6a71f691292ea20c07bfc32b783b8a08a9"
  license all_of: ["BSD-4-Clause-UC", "APSL-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7683b4348e7fc4f1170c3be8a3d282cf65572c82581eaa8ebf9151bd09fb7670"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39af0c922c6db7c331dbcf63c14831c02dc9b8724b6aaa0ce893c79571437721"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "420b61c1995caeb463181faf7576a2e7d4688eead5c47a92c2f112a6ec02b494"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "451c787a0907689e34c433448e9428d72c330f72300256ae3faa42557647d9d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc24db7265b969fa2120ca97606aaed36ffde687c89bf7822be08f759cadcb46"
    sha256 cellar: :any_skip_relocation, ventura:        "1be6b7b6a17a311fb3a2f1bffe7dae52284f3239b8af03f651c4fac11362f702"
    sha256 cellar: :any_skip_relocation, monterey:       "d1f70d1634a9a81032516d0b9c7a5553fe9f643b1dd0563ec99bfd6e7d689e40"
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
