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
    rebuild 1
    sha256 arm64_tahoe:    "6f84ebd03efc6f1b60886a25c819fab4989b5ce8c9b872c217f04e63c5b8afc5"
    sha256 arm64_sequoia:  "f61324276719da51b51203bba9f88739b126e242ee458f65b98cf04492e01114"
    sha256 arm64_sonoma:   "748aa1b21377ed7009f151bb4e9f8beb240f52bc8b8e5cb68e88b4a5928eafdf"
    sha256 arm64_ventura:  "e5d604b100f9911bd2d61f4f4c2bfc5bc3121734de1cef9beedb7b5ae06b1a67"
    sha256 arm64_monterey: "f580bc8117485a0a4be18f76ffa5d3c5764aa04e1d4eb6b3e17b64239d88fb4d"
    sha256 arm64_big_sur:  "4737739b57d119d07cca0689481151e9ed2a815d3e026d85be4354ef76200877"
    sha256 sonoma:         "01f967e4fe8aa9edd73611dfbbc96a43cc687f4e9aaffa97e0522246a112a510"
    sha256 ventura:        "4e099a2079eb825d49c09fd0214bdde20e9b0e52754d73b920de4de4aaa5a7bd"
    sha256 monterey:       "109f5b7057ce61a14f6eb11eb87afb90305b0dc7d830d6ce8d70872e9338b939"
    sha256 big_sur:        "bacf30e9986bb179127942abea49fac9ca05cf1ac3b3851cf3faf1cb970009b4"
    sha256 catalina:       "b0791e6725e6d07610847df7e4431e5839fcf72120cea34f1890b425f8e024c4"
    sha256 arm64_linux:    "7130ab9c8a0eefe2d3ff191ac2541f119bdb2b55eaff706fefdf5b57bea2f797"
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
