class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v17.3.8.75.tar.gz"
  sha256 "ac65fd78b01dc46937bcf77f585e4a770acfa269d0a907c04db6636ced71f619"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "efd5d01681ac104e8c2599465461cf2b7947dde91d65c9e69cd4c62702f71782" => :sierra
    sha256 "4383bca9fa4851ebc2c4b604b4b737b6a3b2aa46cc3bcd0067fef7caa97d11fc" => :el_capitan
    sha256 "8c7be4949f3b3cbc733e117734f33de5a9a05835a1db187b9fccc78f043f9f49" => :yosemite
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
