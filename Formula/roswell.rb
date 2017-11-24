class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v17.11.10.85.tar.gz"
  sha256 "63b078d7f8735eaf8c1e97d4b2b9f386fc765fad146ed66f19ae4a0fb4f60df7"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "5ccaa4445940a0033ba14045c6dd5b58467a533766dd605b2acded79820554d1" => :high_sierra
    sha256 "4080da6092a2d496bf5863fb95a66eb8a89b850f884321cfbcdfee9e4bdab208" => :sierra
    sha256 "02b49a7de62b160f48a6f3c9881f07e4b7d8d32f1b4d1cf5dad739adc9bf7db9" => :el_capitan
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
