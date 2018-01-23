class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v18.1.10.87.tar.gz"
  sha256 "b30102972cdcabc18fa6840741b00641523d93f422a5f8d641896c3b895955b6"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "5f5178f46bb1364f495e130d720da0c24aac8169285c2be76089553b3152ef90" => :high_sierra
    sha256 "d6cab4017070768918f4dd50a3d2fce94f585e58ef046ba785cf388642847440" => :sierra
    sha256 "0541cba77f19e5a014f7d81a8c53b858cdaf02b7f5b965fd1c7b08d6d05f89e2" => :el_capitan
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
