class Telnetd < Formula
  desc "TELNET server"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/remote_cmds/archive/refs/tags/remote_cmds-303.141.1.tar.gz"
  sha256 "5b434a619008406a798af1d724591f6a71f691292ea20c07bfc32b783b8a08a9"
  license all_of: ["BSD-4-Clause-UC", "BSD-3-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0981e34d3f11237109f2a8ae1c06fcf74107dac1041db5398ca2c9960ac28410"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90a0461f0e2548b2b64bf6c84c30654401696632b60b650b532d49e03471281b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb4d6ccbfed1c663629001f590d5328dd4bc5235b98aad628d9e0b918ace86b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c4d31ac7909b6b79275d6f08b2e0ac8c5ff67c4af4c55472b9d5244cf63a857"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4ecd04f334f60b6944402ec2a9a761956b97e77f599aa3a7f10e0bae3e42bab"
    sha256 cellar: :any_skip_relocation, ventura:        "fbd68a8c5507c6c9ed80a1a3fb9002904424a628d48c6a944b5c28b0eb4add1a"
    sha256 cellar: :any_skip_relocation, monterey:       "c0f1d50c09d4631571033155a098aefc6d07d09e424e8888f945e86c71cc42b4"
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
