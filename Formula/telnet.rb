class Telnet < Formula
  desc "User interface to the TELNET protocol"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/remote_cmds/remote_cmds-63.tar.gz"
  sha256 "13858ef1018f41b93026302840e832c2b65289242225c5a19ce5e26f84607f15"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc7703272c5912ca4c44b79b8969478fc5742eef6740de8af55db189a4d1dbb7" => :catalina
    sha256 "d63cb3bdfa4f1dce67cf0956b2fa36d15b0a429a71a6e5538df1a9f517b76589" => :mojave
    sha256 "31ab0f184327fd51fa3273df44bb3f4f2fd78049c15998795fea7e7ee72439d8" => :high_sierra
    sha256 "fd42af8e2c7670c2554ee11c6443f701f6045b9a89c40d3a8463232a8a9a7f90" => :sierra
    sha256 "048572040593f5674d28136d7de979e03b276f96e1063c930709b22527b963e2" => :el_capitan
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
