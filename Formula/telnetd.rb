class Telnetd < Formula
  desc "TELNET server (built from macOS Sierra sources)"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/remote_cmds/remote_cmds-54.50.1.tar.gz"
  sha256 "156ddec946c81af1cbbad5cc6e601135245f7300d134a239cda45ff5efd75930"

  keg_only :provided_pre_high_sierra

  depends_on :xcode => :build

  resource "libtelnet" do
    url "https://opensource.apple.com/tarballs/libtelnet/libtelnet-13.tar.gz"
    sha256 "e7d203083c2d9fa363da4cc4b7377d4a18f8a6f569b9bcf58f97255941a2ebd1"
  end

  def install
    resource("libtelnet").stage do
      xcodebuild "SYMROOT=build"

      libtelnet_dst = buildpath/"telnetd.tproj/build/Products"
      libtelnet_dst.install "build/Release/libtelnet.a"
      libtelnet_dst.install "build/Release/usr/local/include/libtelnet/"
    end

    system "make",
           "-C", "telnetd.tproj",
           "OBJROOT=build/Intermediates",
           "SYMROOT=build/Products",
           "DSTROOT=build/Archive",
           "CFLAGS=$(CC_Flags) -isystembuild/Products/",
           "LDFLAGS=$(LD_Flags) -Lbuild/Products/"

    sbin.install "telnetd.tproj/build/Products/telnetd"
    man8.install "telnetd.tproj/telnetd.8"
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
