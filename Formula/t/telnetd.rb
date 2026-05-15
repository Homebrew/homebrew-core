class Telnetd < Formula
  desc "TELNET server"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/remote_cmds/archive/refs/tags/remote_cmds-308.tar.gz"
  sha256 "cd4fb9d239a4db871c1e82416c42f8862fab26b9f32e292bcf61151a67174168"
  license all_of: ["BSD-4-Clause-UC", "BSD-3-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c105baed35a24dd47445623e2311182421089a4dec205138b73b763420895631"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d06771bdf55dc0ad645128f4f840b5e289b58de6c00ded464bb936f33f0c628"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2baf1b012d677c75baf0893dd502d7d0bc112b590376cea9f25b5fdb88324f68"
    sha256 cellar: :any_skip_relocation, sonoma:        "89af5018ee8282b1ddf26227227034578112802aeb0bbfaf109e741706567ee7"
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
    port = free_port.to_s
    spawn sbin/"telnetd", "-debug", port
    sleep 2
    system "nc", "-vz", "127.0.0.1", port
  end
end
