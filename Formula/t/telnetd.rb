class Telnetd < Formula
  desc "TELNET server"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/remote_cmds/archive/refs/tags/remote_cmds-294.tar.gz"
  sha256 "6e0a4a9cd79fa412f41185333588bc5d4e66a97dc6a2275418c97fb17abb3528"
  license all_of: ["BSD-4-Clause-UC", "BSD-3-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3cbcfdac3525e9666ca44be302cf74271de6c714bbd1b0aaab04d1b88dcdf4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48d96f622cf9dc9eef9d75fe88fbbfcc60c2d74b8b46352143f8c4a04686e298"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "593258deadd1c5b270079e633a557c841ca411ff40b281d00c175ba797cfb1c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "9829b0984a11bfb5397e7461ce6f64e1f405c22250d8e928df3e68546afe6d48"
    sha256 cellar: :any_skip_relocation, ventura:        "7a79abbe7d8717f5ab5297bd819885b8043d06bf306d7341259eed947ce6a365"
    sha256 cellar: :any_skip_relocation, monterey:       "44d9e09f1d8ec49536fe86dfce5d703b37019e885ab65a5cdb99679ff7d66eb6"
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
