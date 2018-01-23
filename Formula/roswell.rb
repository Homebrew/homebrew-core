class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v18.1.10.87.tar.gz"
  sha256 "b30102972cdcabc18fa6840741b00641523d93f422a5f8d641896c3b895955b6"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "56c063c2c51b24b08cb1b740721111b11e4e3b4268cffae36fdc99379b6e96a2" => :high_sierra
    sha256 "e2ecccffc3afa0105556d39e23e79cc0e7090d93eaa653b577531ac27eb8ac28" => :sierra
    sha256 "e0540207e5d7d8b04dc2581310430429cf90d1b4dad238e894179addb7774450" => :el_capitan
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
