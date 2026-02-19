class Swftools < Formula
  desc "SWF manipulation and generation tools"
  homepage "https://github.com/swftools/swftools"
  url "https://distfiles.macports.org/swftools/swftools-0.9.2.tar.gz"
  mirror "http://www.swftools.org/swftools-0.9.2.tar.gz"
  sha256 "bf6891bfc6bf535a1a99a485478f7896ebacbe3bbf545ba551298080a26f01f1"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://raw.githubusercontent.com/swftools/swftools/HEAD/ChangeLog"
    regex(/^v?(\d+(?:\.\d+)+):/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "31fb92ff926fc96545a474c61befc91c622e4cfc4651bfc73b05f2872e12a869"
    sha256 arm64_sequoia: "42b6962749fa8b8cb8b7a7ddf8c4eb9fe6d184df6dd91e0935f4e64af47972cc"
    sha256 arm64_sonoma:  "61eb8ad9f33f851da8b00500c356cb8187fba24bee4398e29e4e8b4292cf9d47"
    sha256 sonoma:        "989fe21084bfc9b4e3e59e5d3ee792fd86fe00a79f32a91c741949e3f5ec9a14"
    sha256 arm64_linux:   "01447110bbf520cc802aa349191b5cd017adfc47dfbcafd496de91919ac9097e"
    sha256 x86_64_linux:  "d6d1fac5d61f11e3b4498b14483518f34e225689c287c1e1f9825ba7ea9ed23b"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fixes a conftest for libfftwf.dylib that mistakenly calls fftw_malloc()
  # rather than fftwf_malloc().  Reported upstream to their mailing list:
  # https://lists.nongnu.org/archive/html/swftools-common/2012-04/msg00014.html
  # Patch is merged upstream.  Remove at swftools-0.9.3.
  # Also fix build on Linux by using correct flags for rm.
  # Linux fix sent to swftools mailing list:
  # https://lists.nongnu.org/archive/html/swftools-common/2022-06/msg00000.html
  patch :DATA

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `voidclass'; ../lib/librfxswf.a(abc.o):(.bss+0x800): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"png2swf", "swftools_test.swf", test_fixtures("test.png")
  end
end

__END__
--- a/configure	2012-04-08 10:25:35.000000000 -0700
+++ b/configure	2012-04-09 17:42:10.000000000 -0700
@@ -6243,7 +6243,7 @@

     int main()
     {
-	char*data = fftw_malloc(sizeof(fftwf_complex)*600*800);
+	char*data = fftwf_malloc(sizeof(fftwf_complex)*600*800);
     	fftwf_plan plan = fftwf_plan_dft_2d(600, 800, (fftwf_complex*)data, (fftwf_complex*)data, FFTW_FORWARD, FFTW_ESTIMATE);
 	plan = fftwf_plan_dft_r2c_2d(600, 800, (float*)data, (fftwf_complex*)data, FFTW_ESTIMATE);
 	plan = fftwf_plan_dft_c2r_2d(600, 800, (fftwf_complex*)data, (float*)data, FFTW_ESTIMATE);
diff --git a/swfs/Makefile.in b/swfs/Makefile.in
index d7bc400..890b9bd 100644
--- a/swfs/Makefile.in
+++ b/swfs/Makefile.in
@@ -41,9 +41,9 @@ install:
 	$(INSTALL_DATA) ./PreLoaderTemplate.swf $(pkgdatadir)/swfs/PreLoaderTemplate.swf
 	$(INSTALL_DATA) ./tessel_loader.swf $(pkgdatadir)/swfs/tessel_loader.swf
 	$(INSTALL_DATA) ./swft_loader.swf $(pkgdatadir)/swfs/swft_loader.swf
-	rm -f $(pkgdatadir)/swfs/default_viewer.swf -o -L $(pkgdatadir)/swfs/default_viewer.swf
+	rm -f $(pkgdatadir)/swfs/default_viewer.swf
 	$(LN_S) $(pkgdatadir)/swfs/simple_viewer.swf $(pkgdatadir)/swfs/default_viewer.swf
-	rm -f $(pkgdatadir)/swfs/default_loader.swf -o -L $(pkgdatadir)/swfs/default_loader.swf
+	rm -f $(pkgdatadir)/swfs/default_loader.swf
 	$(LN_S) $(pkgdatadir)/swfs/tessel_loader.swf $(pkgdatadir)/swfs/default_loader.swf

 uninstall:
