class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v16.11.7.70.tar.gz"
  sha256 "4df54132d9113fa08110c0d23c9536f1b1aaf5bf7956800548478a6b2cdee346"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "2527c93cda7bd5cd58bf493d43bd78615657d57feed35a8b17bb3b4b337c2413" => :sierra
    sha256 "ffdd81e705031d866b4a5e2b6f780a7785c1a0c99a3a36ba902ac1fb1f61819c" => :el_capitan
    sha256 "2832645991bbf61a826ec3b72ea7ae1a0ad02f376f6ce5a3bd5ed77e202f3b1b" => :yosemite
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
