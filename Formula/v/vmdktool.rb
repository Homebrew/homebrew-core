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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c80ae2a1f31f2ce299e628833d1e506ac03b5a0a27ba6ad7cae14455a62eec1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6b696de071b46d21d0b6fd5848fd41fcad54f3ce26c2dbef9ac1373c9bda662"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48fed94d60e7b407531edb37fe6750ed74d982524d5e5497c731eacc3c2c9fbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a26422ba4a199adc6522ab9493a017e13c3c08d9d7996b847fbcefddb692b11d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eb533d8189838729771f500e530db0e691947b3bb774706b831ee3d59701184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0293474570a72314f6b3b336a82ed951d1df9779fbd127aa02e441932f4c31c"
  end

  depends_on "groff" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Fixes "call to undeclared library function 'tolower' with type 'int (int)'".
    inreplace "expand_number.c",
              "#ifndef __APPLE__\n#include <ctype.h>\n#endif",
              "#include <ctype.h>"

    system "make", "CFLAGS=-D_GNU_SOURCE -g -O -pipe"

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
    system bin/"vmdktool", "-v", "blank.vmdk", "blank.raw"
    # Inspect the VMDK with vmdktool
    output = shell_output("#{bin}/vmdktool -i blank.vmdk")
    assert_match "RDONLY 20480 SPARSE", output
    assert_match "streamOptimized", output
  end
end
