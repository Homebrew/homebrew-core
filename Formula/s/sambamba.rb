class Sambamba < Formula
  desc "Tools for working with SAM/BAM data"
  homepage "https://lomereiter.github.io/sambamba/"
  url "https://github.com/biod/sambamba/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "955a51a00be9122aa9b0c27796874bfdda85de58aa0181148ef63548ea5192b0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ddb87f1e11e5f6c241ba9165e9902311d40216ce3a5a7fac3b0d020e24ff17cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ec988d75fd0cb7ceb2c2ba1ce9e4081e70004caca8ac99793f1d0452a2afe32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad59fcbbff179f5b753d40baf1c9e1e1b9e24feef3275d38e409d3199e3e9d55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc71f03090dc0b8a09e1309f436ac38bd4eb6963e6a057e37bf8503323864cce"
    sha256 cellar: :any,                 sonoma:         "12d22d28d83f10dc8d26d12de9b7b826ea88623b432068cbe2f470cc07c24fe4"
    sha256 cellar: :any_skip_relocation, ventura:        "40d87797c5a61358da3981c7a1e798fe72b6c1047407b4d8a0f37c21d7b056f2"
    sha256 cellar: :any_skip_relocation, monterey:       "4ba6feddd3eeafa845c0f66dc6aea389f554c09a8a0c3609644fa44d028e5563"
    sha256 cellar: :any_skip_relocation, big_sur:        "da17c4589ffb5d927025ce617fafa051c6690665643f5c5544b319882b3bf298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1981702ab5c074bebeb8054d69f81b4d6df4daea2907026efae832baa8d362ae"
  end

  depends_on "ldc" => :build
  depends_on "lz4"

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  # remove `-flto=full` flag
  patch :DATA

  def install
    system "make", "release"
    bin.install "bin/sambamba-#{version}" => "sambamba"
  end

  test do
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/biod/sambamba/f898046c5b9c1a97156ef041e61ac3c42955a716/test/ex1_header.sam"
      sha256 "63c39c2e31718237a980c178b404b6b9a634a66e83230b8584e30454a315cc5e"
    end

    resource("homebrew-testdata").stage testpath
    system "#{bin}/sambamba", "view", "-S", "ex1_header.sam", "-f", "bam", "-o", "ex1_header.bam"
    system "#{bin}/sambamba", "sort", "-t2", "-n", "ex1_header.bam", "-o", "ex1_header.sorted.bam", "-m", "200K"
    assert_predicate testpath/"ex1_header.sorted.bam", :exist?
  end
end

__END__
diff --git a/Makefile b/Makefile
index 57bbc55..1faa80d 100644
--- a/Makefile
+++ b/Makefile
@@ -41,7 +41,6 @@ endif

 BIOD_PATH=./BioD:./BioD/contrib/msgpack-d/src
 DFLAGS      = -wi -I. -I$(BIOD_PATH) -g -J.
-LDFLAGS     = -L=-flto=full

 # DLIBS       = $(LIBRARY_PATH)/libphobos2-ldc.a $(LIBRARY_PATH)/libdruntime-ldc.a
 # DLIBS_DEBUG = $(LIBRARY_PATH)/libphobos2-ldc-debug.a $(LIBRARY_PATH)/libdruntime-ldc-debug.a
