class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v16.12.7.71.tar.gz"
  sha256 "df0887d2b86afc26fa82381e2f798c4fa1d77b1e7c23edf5a21fa9e612c3d9d9"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "8e2850fc87687cc75fe0dde24e23561935842f9d7a9db340a4a37beb4fc67497" => :sierra
    sha256 "e3f44ea01b882a18ab7a22f90cc855c6e10864ce2d2f429f4c89ddfc60a6f531" => :el_capitan
    sha256 "fcbe2af0d80071743ae6d56694dabf156109fbe4504241ae6400af7dda53efac" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-manual-generation",
                          "--enable-html-generation",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    File.exist? testpath/".roswell/config"
  end
end
