class Swftools < Formula
  desc "SWF manipulation and generation tools"
  homepage "http://www.swftools.org/"
  url "http://www.swftools.org/swftools-0.9.2.tar.gz"
  sha256 "bf6891bfc6bf535a1a99a485478f7896ebacbe3bbf545ba551298080a26f01f1"
  revision 1

  bottle do
    sha256 "479570fcb99302996b55c361db1a6bb4a3abee611533b854fa350956f6b8cf61" => :sierra
    sha256 "7343a6c406b0374b460f1d814e5542372f85df5d6ee500759648084713e33174" => :el_capitan
    sha256 "f672348156459f385c6b08ed67c7055cd1cb9ee9dee8d868777596a57ac01a7f" => :yosemite
    sha256 "7f18b7dae61164cd47eb34712884dea4de8df821d51ce955c6c33f36c165eaa1" => :mavericks
    sha256 "900f2dd522f48c9ea72a3bf8dba53a8f0f35a4867dc68fab5dc85921a769c206" => :mountain_lion
  end

  option "with-xpdf", "Build with PDF support"

  depends_on :x11 if build.with? "xpdf"
  depends_on "jpeg" => :optional
  depends_on "lame" => :optional
  depends_on "fftw" => :optional

  resource "xpdf" do
    url "ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.04.tar.gz", :using => :nounzip
    sha256 "11390c74733abcb262aaca4db68710f13ffffd42bfe2a0861a5dfc912b2977e5"
  end

  # Fixes a conftest for libfftwf.dylib that mistakenly calls fftw_malloc()
  # rather than fftwf_malloc().  Reported upstream to their mailing list:
  # https://lists.nongnu.org/archive/html/swftools-common/2012-04/msg00014.html
  # Patch is merged upstream.  Remove at swftools-0.9.3.
  patch :DATA

  def install
    (buildpath/"lib/pdf").install resource("xpdf") if build.with? "xpdf"
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
