class Sambamba < Formula
  desc "Tools for working with SAM/BAM data"
  homepage "https://lomereiter.github.io/sambamba/"
  url "https://github.com/biod/sambamba/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "955a51a00be9122aa9b0c27796874bfdda85de58aa0181148ef63548ea5192b0"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "995c464037926a0520fba05804aa852d59632359ca69fc5790f01a408c6ca23e"
    sha256 cellar: :any,                 arm64_sequoia: "44b20d7fcc0b1828d02be2a4806ebce8186a037de50bb00b81ae78d41b7e9897"
    sha256 cellar: :any,                 arm64_sonoma:  "6ee13b99ad2f3efbfa9ce7432afcddfdab1b6e9c650264fdef26ed7013e02ba0"
    sha256 cellar: :any,                 sonoma:        "7fac5a9ba6145a7b151b1930b490705bfa420f7b2ca73d0a2eea06c93e815426"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7d72d27c226414501cbc4c4d96dbc5df33e071e8aa3b343851ed77648d292be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca216432fad1f1c7c38d6805f8f819c81cf1f85522fcfb7046e89941ccd94d70"
  end

  depends_on "ldc" => :build
  depends_on "lz4"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # remove `-flto=full` flag
  patch :DATA

  # Fix to add missing break for case statement, should remove in next release
  patch do
    url "https://github.com/biod/sambamba/commit/5fdcf6f3015cb17b805514397223f7513bc92613.patch?full_index=1"
    sha256 "f51a32a00102478aa8c9a0c36975a33438fd474992127a757d9a4732b10e6695"
  end

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
    system bin/"sambamba", "view", "-S", "ex1_header.sam", "-f", "bam", "-o", "ex1_header.bam"
    system bin/"sambamba", "sort", "-t2", "-n", "ex1_header.bam", "-o", "ex1_header.sorted.bam", "-m", "200K"
    assert_path_exists testpath/"ex1_header.sorted.bam"
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
