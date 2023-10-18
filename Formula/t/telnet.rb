class Telnet < Formula
  desc "User interface to the TELNET protocol"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/remote_cmds/archive/refs/tags/remote_cmds-294.tar.gz"
  sha256 "6e0a4a9cd79fa412f41185333588bc5d4e66a97dc6a2275418c97fb17abb3528"
  license all_of: ["BSD-4-Clause-UC", "APSL-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65ecacf9d9f7dbccce0052d3cb629dd207182004ec7b15922fa8d14b2603830f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cbefbf43011476c9654555d91da826446f1e031f560300756b4e7d718334b59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87545e9d53b88d570faaf2dbf9324e34d17cc482f411d5a55e2149b5d035dea6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f41f5302e482420f00aaf510a8505c529be0363f0177c0a661b9cc4315947d10"
    sha256 cellar: :any_skip_relocation, ventura:        "86a02f306e17b25e31e2a2c339305b90593846ac2099458c387eacea10b2fc11"
    sha256 cellar: :any_skip_relocation, monterey:       "2df800b710be4d192dab548cb9a0386a04a21c422cb0dab951288a158ca637af"
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
