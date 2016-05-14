class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v0.0.5.62.tar.gz"
  sha256 "9ca42a849914ada9c9da495205c9d0cdade4d3b39cd7ac38821bacc1a4ef638a"
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
