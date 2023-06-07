class Telnetd < Formula
  desc "TELNET server"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/remote_cmds/archive/refs/tags/remote_cmds-69.tar.gz"
  sha256 "ce917122a88f8bee98686476abf83f1d442e387637a021eabe02f0fe88e02986"
  license all_of: ["BSD-4-Clause-UC", "BSD-3-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dba6dea88d5fc55f04dfb5add2808353bc8a0d92b55da830fef8c0a9e0a4700d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf9395dac9ec95948423af592f27d33b4e5b84e3890ed4f331d01d2f76e65441"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66b6001b5d7d4b96918ea9f1dc09eb5635f1c4b2ffad3b597cce00adf4d6e6b7"
    sha256 cellar: :any_skip_relocation, ventura:        "59d5ebd74ddd33d27981718ea17686a35940cede1067a06cf6b75fe2051e3288"
    sha256 cellar: :any_skip_relocation, monterey:       "39a6fd07335f285b0296610c4c7ef6b44bce6ba7528252946751af175271fc57"
    sha256 cellar: :any_skip_relocation, big_sur:        "767e20e14340204c5e5720320a64128640b983b410897aa116e316e79168b203"
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

    # fmtcheck(3) is used in several format strings, which is not a literal and thus
    # throws an error (-Werror, -Wformat-nonliteral). Remove once possible to build
    # without adding this flag.
    ENV.append_to_cflags "-Wno-format-nonliteral"

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
  end
end
