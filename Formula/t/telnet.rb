class Telnet < Formula
  desc "User interface to the TELNET protocol"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/remote_cmds/archive/refs/tags/remote_cmds-302.tar.gz"
  sha256 "04b3e1253eee08e82e705a199f8ee1e99608304797911e9e69ab2c5c63d734c8"
  license all_of: ["BSD-4-Clause-UC", "APSL-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32fb300ad90af4a38af9f64c7bc790796ecf63deef9cfd0583a030cd8131a9df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf9c1370dfd3791b56daef5d704a5cb5bb8139a0ca4590b2bf38c0e2f59fd4ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0292887da28386ae889224191f63336215451b20e5bf4e2bc7f8e395cd4f5f2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "647c1a4caf092da6ed267f755d2fc8e9878f00fb77ba9a25e524a2fc80452a85"
    sha256 cellar: :any_skip_relocation, ventura:        "440542cac7a1521c34234d7b992688031f709d673b0cfc949addb2f2401170a3"
    sha256 cellar: :any_skip_relocation, monterey:       "fba4c8392b21fce4c00c34f7c300d96d7cde052d19d461c0fce7db0d3ddffff6"
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
