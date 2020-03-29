class Telnetd < Formula
  desc "TELNET server"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/remote_cmds/remote_cmds-63.tar.gz"
  sha256 "13858ef1018f41b93026302840e832c2b65289242225c5a19ce5e26f84607f15"

  bottle do
    cellar :any_skip_relocation
    sha256 "16f053b3bdfe04dcad271f63cd1f7e6ccc312ddb410081f4f729d12bc80eceb9" => :catalina
    sha256 "cde731ff626ebda39ecadc5b6ed2014429cb2afb99521fd967a2176d127d94b7" => :mojave
    sha256 "d31eb6a8f79b8f9eb2417dce87c6508b8837207d4f8df48bdd5fd1d833f1b757" => :high_sierra
  end

  depends_on :xcode => :build

  resource "libtelnet" do
    url "https://opensource.apple.com/tarballs/libtelnet/libtelnet-13.tar.gz"
    sha256 "e7d203083c2d9fa363da4cc4b7377d4a18f8a6f569b9bcf58f97255941a2ebd1"
  end

  def install
    resource("libtelnet").stage do
      # Force 64 bit-only build, otherwise it fails on Mojave
      xcodebuild "SYMROOT=build", "-arch", "x86_64"

      libtelnet_dst = buildpath/"telnetd.tproj/build/Products"
      libtelnet_dst.install "build/Release/libtelnet.a"
      libtelnet_dst.install "build/Release/usr/local/include/libtelnet/"
    end

    system "make", "-C", "telnetd.tproj",
                   "OBJROOT=build/Intermediates",
                   "SYMROOT=build/Products",
                   "DSTROOT=build/Archive",
                   "CC=#{ENV.cc}",
                   "CFLAGS=$(CC_Flags) -isystembuild/Products/",
                   "LDFLAGS=$(LD_Flags) -Lbuild/Products/",
                   "RC_ARCHS=x86_64" # Force 64-bit build for Mojave

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
