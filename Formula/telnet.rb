class Telnet < Formula
  desc "User interface to the TELNET protocol (built from macOS Sierra sources)"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/remote_cmds/remote_cmds-60.tar.gz"
  sha256 "9d27417d5032113e93edebc37f82a060536bc557b119544e59c46aeb1be92820"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f68d8152cca7ae73a3c598d55d58083ef4795f1ace88794ea949baa21a75c975" => :high_sierra
    sha256 "62d5a07da6030b6006f16572ad3b1d17aee0a09d03c8690ffaed964c6bd089ae" => :sierra
    sha256 "13911a70794917c973d7cd56450f02ec376819542053a5954cb6264ca31c21f5" => :el_capitan
  end

  depends_on :xcode => :build

  conflicts_with "inetutils", :because => "both install 'telnet' binaries"

  resource "libtelnet" do
    url "https://opensource.apple.com/tarballs/libtelnet/libtelnet-13.tar.gz"
    sha256 "e7d203083c2d9fa363da4cc4b7377d4a18f8a6f569b9bcf58f97255941a2ebd1"
  end

  def install
    resource("libtelnet").stage do
      ENV["SDKROOT"] = MacOS.sdk_path
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      # Force 64 bit-only build, otherwise it fails on Mojave
      xcodebuild "SYMROOT=build", "-arch", "x86_64"

      libtelnet_dst = buildpath/"telnet.tproj/build/Products"
      libtelnet_dst.install "build/Release/libtelnet.a"
      libtelnet_dst.install "build/Release/usr/local/include/libtelnet/"
    end

    system "make", "-C", "telnet.tproj",
                   "OBJROOT=build/Intermediates",
                   "SYMROOT=build/Products",
                   "DSTROOT=build/Archive",
                   "CFLAGS=$(CC_Flags) -isystembuild/Products/",
                   "LDFLAGS=$(LD_Flags) -Lbuild/Products/",
                   "RC_ARCHS=x86_64", # Force 64-bit build for Mojave
                   "install"

    bin.install "telnet.tproj/build/Archive/usr/local/bin/telnet"
    man1.install "telnet.tproj/telnet.1"
  end

  test do
    output = shell_output("#{bin}/telnet 94.142.241.111 666", 1)
    assert_match "Connected to towel.blinkenlights.nl.", output
  end
end
