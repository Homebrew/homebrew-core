class Telnetd < Formula
  desc "TELNET server (built from macOS Sierra sources)"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/remote_cmds/remote_cmds-54.50.1.tar.gz"
  sha256 "156ddec946c81af1cbbad5cc6e601135245f7300d134a239cda45ff5efd75930"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "61c06e02268d33b84484ba991221493ef0d01dfcff6c4e655ff831c3f7fc6f51" => :mojave
    sha256 "6c0d7658f3f74e12ea983a72907635a0444d97290b43c604b96218b4e6ca52d1" => :high_sierra
    sha256 "43e4d4a2eb55629583d76ce9c6131f2ce1d4868b90d2e24a170ffc63f4947c8a" => :sierra
    sha256 "87932091398ba2cddf14298d70ce1b17ebb7c1e734e177807f23444a44987df2" => :el_capitan
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
