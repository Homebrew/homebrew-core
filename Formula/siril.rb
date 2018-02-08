class Siril < Formula
  desc "Astronomical image (pre-)processing application"
  homepage "https://free-astro.org/index.php/Siril"
  url "https://free-astro.org/download/siril-0.9.8.tar.bz2"
  sha256 "ecb5477937afc02cc89cb07f4a7b99d2d0ab4cc5e715ec536e9be5c92a187170"
  head "https://free-astro.org/svn/siril/"

  bottle do
    sha256 "5c75d117d251a7708d744a09f5c7713e50abe259be256a93f9987c63f4e4881a" => :sierra
    sha256 "24c5f64cd4377dab1195fa5170a45ca17d9171fb5bb66f6a36f407e4b48bb42e" => :el_capitan
  end

  option "without-openmp", "Disable OpenMP"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "llvm"
  depends_on "ffms2"
  depends_on "fftw"
  depends_on "adwaita-icon-theme"
  depends_on "openjpeg"
  depends_on "cfitsio"
  depends_on "libconfig"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsvg"
  depends_on "netpbm"
  depends_on "gsl"
  depends_on "opencv"
  depends_on "gnuplot" => :optional
  depends_on "gtk-mac-integration" if OS.mac?

  if build.with? "openmp"
    depends_on "gcc"
    needs :openmp
    needs :cxx11
  end

  patch :DATA

  def install
    ENV.cxx11 if build.with? "openmp"

    args = ["--prefix=#{prefix}"]
    args << "--enable-openmp" if build.with? "openmp"
    system "./autogen.sh", *args
    system "make", "install"
    bin.install "src/siril"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end

__END__
--- a/src/io/avi_pipp/pipp_avi_write.h
+++ b/src/io/avi_pipp/pipp_avi_write.h
@@ -221,7 +221,6 @@
         int32_t m_bytes_per_pixel;
         int64_t m_last_frame_pos;
         int64_t m_riff_start_position;
-        std::string m_error_string;
         bool m_file_write_error;

         c_pipp_buffer m_temp_buffer;
