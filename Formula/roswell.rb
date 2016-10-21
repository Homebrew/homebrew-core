class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v0.0.6.68.tar.gz"
  sha256 "07719ec7cc773d40dec37e58e4b60f09267349aa6de8ddbae101e8d18f25c911"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "b19d3188685acda7c1211a5156ca04f2c69b5cef4ad55a71203e07b4094de038" => :sierra
    sha256 "9a26eaec144b811c4de52f92bb4d0b77793215c1289769a16f537ceb2955f189" => :el_capitan
    sha256 "d1c8e8e30d1803b5874fcf125ae4de08e8e3d3a5826656bf9ec8f092e6d81489" => :yosemite
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
