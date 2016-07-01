class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v0.0.6.64.tar.gz"
  sha256 "f9b7a3ada298e62d024b612136196d8564e36650da59b6cc72cfb6c9bdaca3c1"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "ea6a74fec4ba793fa0d6fae1f93634fcac5faeeceed25feb0304de5b609c5618" => :el_capitan
    sha256 "a4cf77ad041fc520255ed1f7fcdddd8ef86ae7d749502b4ea61ae77a83ebb3f1" => :yosemite
    sha256 "5fa7d4681265c25146c5b805d3aad23957aca4bcf20108a355e96a6856062a56" => :mavericks
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
