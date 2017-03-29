class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v17.3.8.75.tar.gz"
  sha256 "ac65fd78b01dc46937bcf77f585e4a770acfa269d0a907c04db6636ced71f619"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "ea88acfbfa12a98720c8ae7b646f7e429242eed2e5ff0264cec28c3c42fa7d13" => :sierra
    sha256 "c39b58fab7e29e6ed9a5d7f936bd0f7f270a9c6e4ba4eaeed8ccf9c5d3f5e14b" => :el_capitan
    sha256 "c0614998e5c3661fcb0070592e718870f68f1abb9d52d156815bdd0a311c4035" => :yosemite
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
