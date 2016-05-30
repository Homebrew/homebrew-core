class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v0.0.6.63.tar.gz"
  sha256 "e40da6ef783e46cb76f239b0667a79b38da6569aed9cac56786f8469f80cbb35"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "1a466571b390507d9ed949ef62323b58642d6d91aaea5f7940b9cf170865c6bb" => :el_capitan
    sha256 "b60e59153b00eb973f2fea2fa1eddca71e5f49546ff3aa8d70b15188089a7eef" => :yosemite
    sha256 "c96d492fdf7d9ebcc8ecd090b931e677fc9ab836062fe670ddee5780a8626609" => :mavericks
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
