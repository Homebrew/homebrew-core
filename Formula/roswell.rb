class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v18.8.10.93.tar.gz"
  sha256 "eb705f5f8c82a862051fd3eb58a8ca1ac3cc2ef2ed85a7409718ab582953eaf0"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "cc4614def8e563ae2bc0440c112f6a52d3a9de49ec8d8b812dbf50c92aca0916" => :high_sierra
    sha256 "181da84c21efeb9ee8b83cc06820c9383db50d2b9e73c163d5bd4d8597be44f7" => :sierra
    sha256 "b06a44335b3153ec53c260db673f71116d12e70312ce32a5f6afa59caca382c3" => :el_capitan
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_predicate testpath/"config", :exist?
  end
end
