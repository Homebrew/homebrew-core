class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v17.5.8.78.tar.gz"
  sha256 "d52093c7f8d42b83da929121294bb89cf0f0a2185ca65f49d788b7ff12c1a54a"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "22e544ecc0d8dc71c550e31d0dabc1f12a2b3e67c00da02b50731596ec5c959b" => :sierra
    sha256 "6c048bfcca2cf5355b38b4a03def01a706009d206fb896963bac0e561776d90a" => :el_capitan
    sha256 "6e68e52b6313165210be7a6d218bbc71d9280605e0b7f6985ac04f16a3adc94d" => :yosemite
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
