class Telnetd < Formula
  desc "TELNET server"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/remote_cmds/archive/refs/tags/remote_cmds-302.tar.gz"
  sha256 "04b3e1253eee08e82e705a199f8ee1e99608304797911e9e69ab2c5c63d734c8"
  license all_of: ["BSD-4-Clause-UC", "BSD-3-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b392539252cd64cd1a0f847923c1b83d6f6aba20b4f4594d99222e04c7346b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43e9e98bd8b38412d9bdfc628bd82d319d1b1584f12c76724d96eed1ad49af6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29c2722fb8e684539e6dde74e7ba462a2eebe26106b65c6e23dd8f6aa987fe03"
    sha256 cellar: :any_skip_relocation, sonoma:         "64bcf2e1e023e8deff7e77863301f3e20d6d804a734a815d12724c326e017968"
    sha256 cellar: :any_skip_relocation, ventura:        "35883264a39478b7aaab5f19938d0f6fe77d38f9383f216f61f336fc1b4dd5b3"
    sha256 cellar: :any_skip_relocation, monterey:       "27e5f41519ee366e55ad4af423d4765b60d472cb64dba6ab5ec23fe981de6fe5"
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
