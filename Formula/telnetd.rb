class Telnetd < Formula
  desc "TELNET server"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/remote_cmds/remote_cmds-63.tar.gz"
  sha256 "13858ef1018f41b93026302840e832c2b65289242225c5a19ce5e26f84607f15"
  license all_of: ["BSD-4-Clause-UC", "BSD-3-Clause"]

  livecheck do
    url "https://opensource.apple.com/tarballs/remote_cmds/"
    regex(/href=.*?remote_cmds[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13567bd6d3032b016085dcba115e8e298c1a95408339ee3ec8fe83ba66252e3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd8bc95b6e361eaab4df4e4b1e65bc20f0f14f6e5b44aa55bde5ea69f3bec59c"
    sha256 cellar: :any_skip_relocation, monterey:       "89758ea7bba66934bfceedb7568fd9d051931cbbe0d10ec6b91a7bea039eb291"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce7113437e6dad49c075791c92c2fa4c0fd16a0ab6c9e3bc01f4ce40b573247f"
    sha256 cellar: :any_skip_relocation, catalina:       "16f053b3bdfe04dcad271f63cd1f7e6ccc312ddb410081f4f729d12bc80eceb9"
    sha256 cellar: :any_skip_relocation, mojave:         "cde731ff626ebda39ecadc5b6ed2014429cb2afb99521fd967a2176d127d94b7"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d31eb6a8f79b8f9eb2417dce87c6508b8837207d4f8df48bdd5fd1d833f1b757"
  end

  depends_on xcode: :build

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

    system "make", "-C", "telnetd.tproj",
                   "OBJROOT=build/Intermediates",
                   "SYMROOT=build/Products",
                   "DSTROOT=build/Archive",
                   "CC=#{ENV.cc}",
                   "CFLAGS=$(CC_Flags) -isystembuild/Products/",
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
