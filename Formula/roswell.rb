class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v17.8.9.81.tar.gz"
  sha256 "15ed3c279c83e934d6f09e324aeec3a0c99105a3811d4c82e1a255e54256857f"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "aac7a88acc9b3bac01c4938abad6cefc38564cbc6fd49d02da90ce2f7da228fa" => :sierra
    sha256 "5ec670c067d9c71245c0b6594ccaa7553cd7e57c15b559f2756de2a7a8d9ec45" => :el_capitan
    sha256 "3e9a30d23fc14fe56609ce03d3a1dc041619ceb12f50394ceb7e3867d669ccd3" => :yosemite
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
