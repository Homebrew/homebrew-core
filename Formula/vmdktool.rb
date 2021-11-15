class Vmdktool < Formula
  desc "Converts raw filesystems to VMDK files and vice versa"
  homepage "https://manned.org/vmdktool"
  url "https://people.freebsd.org/~brian/vmdktool/vmdktool-1.4.tar.gz"
  sha256 "981eb43d3db172144f2344886040424ef525e15c85f84023a7502b238aa7b89c"
  license "BSD-2-Clause"

  livecheck do
    url "https://people.freebsd.org/~brian/vmdktool/"
    regex(/href=.*?vmdktool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7823dbeb8f044ce3183f1ea2d6ebec16ce30fc9fe2951cc55b84c5a9043f8569"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a19ea885fcf69d6929cb155489aab52543b1b1f456eedf9f49f3f6eebf51ec9"
    sha256 cellar: :any_skip_relocation, monterey:       "9d68c339c6dfb87f9cc70d1df15e36337b2a57cbae54825b24a2c7dc1e4096dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f3f1adccbe9d28c54b0009c00866636ab7872914ff6587ccf206f15cb08ac68"
    sha256 cellar: :any_skip_relocation, catalina:       "2d4faffbb4ae8f2aba0822834278e532c08fad14e8b07ef534415e1535e3c369"
    sha256 cellar: :any_skip_relocation, mojave:         "13ed1b70d5c6d7f7411df7736940bf9fcd220fa92b229b79558e648cbdc0a641"
    sha256 cellar: :any_skip_relocation, high_sierra:    "276a35d178515782c7a741a2ebd45c6b47aee0d7ecfd725c386f589e69336fdc"
    sha256 cellar: :any_skip_relocation, sierra:         "3fa294be9d6e9e6b56435526520262aaa86f5909cc10b9ccf9d9670ae3ac0e3c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "8604a90f9ad0f3b04767c021a4d24dacdcabd788767df56a45e3913231d4336e"
    sha256 cellar: :any_skip_relocation, yosemite:       "f19ae3ac92ae4400c7139771f3a5ec07d32bf2e3ed49bfa7add445f8a680ef0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c1d93d16f35a13226a5b332895c50d04badd06732ff6b69094dc1844db8c98d"
  end

  uses_from_macos "zlib"

  def install
    system "make", "CFLAGS='-D_GNU_SOURCE -g -O -pipe'"

    # The vmdktool Makefile isn't as well-behaved as we'd like:
    # 1) It defaults to man page installation in $PREFIX/man instead of
    #    $PREFIX/share/man, and doesn't recognize '$MANDIR' as a way to
    #    override this default.
    # 2) It doesn't do 'install -d' to create directories before installing
    #    to them.
    # The maintainer (Brian Somers, brian@awfulhak.org) has been notified
    # of these issues as of 2017-01-25 but no fix is yet forthcoming.
    # There is no public issue tracker for vmdktool that we know of.
    # In the meantime, we can work around these issues as follows:
    bin.mkpath
    man8.mkpath
    inreplace "Makefile", "man/man8", "share/man/man8"

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Create a blank disk image in raw format
    system "dd", "if=/dev/zero", "of=blank.raw", "bs=512", "count=20480"
    # Use vmdktool to convert to streamOptimized VMDK file
    system "#{bin}/vmdktool", "-v", "blank.vmdk", "blank.raw"
    # Inspect the VMDK with vmdktool
    output = shell_output("#{bin}/vmdktool -i blank.vmdk")
    assert_match "RDONLY 20480 SPARSE", output
    assert_match "streamOptimized", output
  end
end
