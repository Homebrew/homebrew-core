class Telnetd < Formula
  desc "TELNET server"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/remote_cmds/archive/refs/tags/remote_cmds-64.tar.gz"
  sha256 "9beae91af0ac788227119c4ed17c707cd3bb3e4ed71422ab6ed230129cbb9362"
  license all_of: ["BSD-4-Clause-UC", "BSD-3-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0f71c7ca40e07b2d12cc1ebcb547960381088891b4800637752d29999e3fdca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1227d7bf27eb7a58adac93e1a210a93c88d940dff07d48017d2858464ddc3b9"
    sha256 cellar: :any_skip_relocation, monterey:       "70b9f81f506d83c50ba321e3920553aaeaa272c35ce798560afdd15da6e259a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fdf31a5dc2042a8ef17900ba7c2d7e87457d27fc656336b023f1b29caaaeac0"
    sha256 cellar: :any_skip_relocation, catalina:       "5e463bafef10793f46d7c38905445a8a8d4141fac5f2ddfcb38710cc8b802210"
  end

  depends_on xcode: :build
  depends_on :macos

  resource "libtelnet" do
    url "https://opensource.apple.com/tarballs/libtelnet/libtelnet-13.tar.gz"
    sha256 "e7d203083c2d9fa363da4cc4b7377d4a18f8a6f569b9bcf58f97255941a2ebd1"
  end

  def install
    resource("libtelnet").stage do
      xcodebuild "SYMROOT=build", "-arch", Hardware::CPU.arch

      libtelnet_dst = buildpath/"telnetd.tproj/build/Products"
      libtelnet_dst.install "build/Release/libtelnet.a"
      libtelnet_dst.install "build/Release/usr/local/include/libtelnet/"
    end

    ENV.append_to_cflags "-isystembuild/Products/"
    system "make", "-C", "telnetd.tproj",
                   "OBJROOT=build/Intermediates",
                   "SYMROOT=build/Products",
                   "DSTROOT=build/Archive",
                   "CC=#{ENV.cc}",
                   "CFLAGS=$(CC_Flags) #{ENV.cflags}",
                   "LDFLAGS=$(LD_Flags) -Lbuild/Products/",
                   "RC_ARCHS=#{Hardware::CPU.arch}"

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
