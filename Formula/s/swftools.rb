class Swftools < Formula
  desc "SWF manipulation and generation tools"
  homepage "http://www.swftools.org/"
  url "http://www.swftools.org/swftools-0.9.2.tar.gz"
  sha256 "bf6891bfc6bf535a1a99a485478f7896ebacbe3bbf545ba551298080a26f01f1"
  revision 1

  livecheck do
    url "http://www.swftools.org/download.html"
    regex(/href=.*?swftools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "e5d604b100f9911bd2d61f4f4c2bfc5bc3121734de1cef9beedb7b5ae06b1a67"
    sha256 arm64_monterey: "f580bc8117485a0a4be18f76ffa5d3c5764aa04e1d4eb6b3e17b64239d88fb4d"
    sha256 arm64_big_sur:  "4737739b57d119d07cca0689481151e9ed2a815d3e026d85be4354ef76200877"
    sha256 ventura:        "4e099a2079eb825d49c09fd0214bdde20e9b0e52754d73b920de4de4aaa5a7bd"
    sha256 monterey:       "109f5b7057ce61a14f6eb11eb87afb90305b0dc7d830d6ce8d70872e9338b939"
    sha256 big_sur:        "bacf30e9986bb179127942abea49fac9ca05cf1ac3b3851cf3faf1cb970009b4"
    sha256 catalina:       "b0791e6725e6d07610847df7e4431e5839fcf72120cea34f1890b425f8e024c4"
    sha256 mojave:         "bf18bfc66b1f6d6ed247acd0a4208a09b4acf6a4668e8f7eba2e40ad33ffe9f6"
    sha256 high_sierra:    "d0e441ed7eef07c3536965d5269f648744ceb62d41fbcfe9a12248b8154c4f62"
    sha256 x86_64_linux:   "0ed51b95634f090cb753b57fdd73df90a944cc37fc2c34de45592d74c8b74139"
  end

  uses_from_macos "zlib"

  # Fixes a conftest for libfftwf.dylib that mistakenly calls fftw_malloc()
  # rather than fftwf_malloc().  Reported upstream to their mailing list:
  # https://lists.nongnu.org/archive/html/swftools-common/2012-04/msg00014.html
  # Patch is merged upstream.  Remove at swftools-0.9.3.
  # Also fix build on Linux by using correct flags for rm.
  # Linux fix sent to swftools mailing list:
  # https://lists.nongnu.org/archive/html/swftools-common/2022-06/msg00000.html
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/png2swf", "swftools_test.swf", test_fixtures("test.png")
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
