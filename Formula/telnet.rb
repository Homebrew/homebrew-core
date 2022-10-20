class Telnet < Formula
  desc "User interface to the TELNET protocol"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/remote_cmds/archive/refs/tags/remote_cmds-64.tar.gz"
  sha256 "9beae91af0ac788227119c4ed17c707cd3bb3e4ed71422ab6ed230129cbb9362"
  license all_of: ["BSD-4-Clause-UC", "APSL-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf76f3b47cf35efd4d271adf52227e463298005ec9b1ac586b629d5ad94522cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee7b09914ace1a19c919373b7199f90bbe1204137ac3412e4d6b129af8afef88"
    sha256 cellar: :any_skip_relocation, monterey:       "e7d411ac808b074f661caf470c170e0c3e01746e818e5654400b7adbc418e941"
    sha256 cellar: :any_skip_relocation, big_sur:        "792bf380076d34dc7e3150ab900c6fabbaac605da31a0a7f3836119fb9ed53ea"
    sha256 cellar: :any_skip_relocation, catalina:       "2ba6a3f8043930a9cf490e88d269c54e8b59697d0a0faa62eb18d389b6ce9c7b"
  end

  depends_on xcode: :build
  depends_on :macos

  conflicts_with "inetutils", because: "both install 'telnet' binaries"

  resource "libtelnet" do
    url "https://opensource.apple.com/tarballs/libtelnet/libtelnet-13.tar.gz"
    sha256 "e7d203083c2d9fa363da4cc4b7377d4a18f8a6f569b9bcf58f97255941a2ebd1"
  end

  def install
    resource("libtelnet").stage do
      ENV["SDKROOT"] = MacOS.sdk_path
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      xcodebuild "SYMROOT=build", "-arch", Hardware::CPU.arch

      libtelnet_dst = buildpath/"telnet.tproj/build/Products"
      libtelnet_dst.install "build/Release/libtelnet.a"
      libtelnet_dst.install "build/Release/usr/local/include/libtelnet/"
    end

    ENV.append_to_cflags "-isystembuild/Products/"
    system "make", "-C", "telnet.tproj",
                   "OBJROOT=build/Intermediates",
                   "SYMROOT=build/Products",
                   "DSTROOT=build/Archive",
                   "CFLAGS=$(CC_Flags) #{ENV.cflags}",
                   "LDFLAGS=$(LD_Flags) -Lbuild/Products/",
                   "RC_ARCHS=#{Hardware::CPU.arch}",
                   "install"

    bin.install "telnet.tproj/build/Archive/usr/local/bin/telnet"
    man1.install "telnet.tproj/telnet.1"
  end

  test do
    output = shell_output("#{bin}/telnet india.colorado.edu 13", 1)
    assert_match "Connected to india.colorado.edu.", output
  end
end
