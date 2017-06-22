class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v17.6.9.79.tar.gz"
  sha256 "46d3381d9dc8e424e78ddd7afef18f78bf695e82acb7441774f69718c634f0a3"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "905da4a755b5400f24dde840bc165245cb56b741aba25c05b8d7a608f997a5ab" => :sierra
    sha256 "ee53406f25e6ccce4e67da0dce53c524ae9a451d43da9858aedbb9ca804de1a8" => :el_capitan
    sha256 "74a4d605719a195745ca1595d0e07f1d011080cfa1d1ac7ea6a8ffa8fbd74722" => :yosemite
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
    assert_predicate testpath/"config", :exist?
  end
end
