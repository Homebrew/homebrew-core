class Telnetd < Formula
  desc "TELNET server"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/remote_cmds/archive/refs/tags/remote_cmds-306.tar.gz"
  sha256 "7f014f7eebb115460ea782e6bcade6d16effa56da17ee30f00012af07bc96c36"
  license all_of: ["BSD-4-Clause-UC", "BSD-3-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "352b9a21a62d85b6636369978ad5b6bffa79323abbd985371f663d6da0c16e30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07bf8f40affa2499a35c1d4721d0f037e12081c299a43df1c11a0a51ebf15ac0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed85960517cbb617e9b60788b809d4909266b9a377d28d714f9a713858fd57da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02ad1e6f02dcf3316ecb981540fcac0ebf600ffe5f24250a830704464742185c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fea7f6cc2ea119744bfa263e2c2a67766d169fb9ed0f73a97a6de8c00a0e06e"
    sha256 cellar: :any_skip_relocation, ventura:       "447534356a8a29764410dcf44c188300ce42e57487f9c8145d81b19d1b0868b4"
  end

  depends_on xcode: :build
  depends_on :macos

  resource "libtelnet" do
    url "https://github.com/apple-oss-distributions/libtelnet/archive/refs/tags/libtelnet-13.tar.gz"
    sha256 "4ffc494a069257477c3a02769a395da8f72f5c26218a02b9ea73fa2a63216cee"
  end

  def install
    resource("libtelnet").stage do
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
               "-target", "telnetd"

    sbin.install "build/Products/Release/telnetd"
    man8.install "telnetd/telnetd.8"
  end

  def caveats
    <<~EOS
      You may need super-user privileges to run this program properly. See the man
      page for more details.
    EOS
  end

  test do
    assert_match "usage: telnetd", shell_output("#{sbin}/telnetd usage 2>&1", 1)
    port = free_port
    fork do
      exec "#{sbin}/telnetd -debug #{port}"
    end
    sleep 2
    system "nc", "-vz", "127.0.0.1", port
  end
end
