class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v17.11.10.85.tar.gz"
  sha256 "63b078d7f8735eaf8c1e97d4b2b9f386fc765fad146ed66f19ae4a0fb4f60df7"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "89472d6028ae82adfe0035726267d92f496cf25fbc9dec93f6fc36a4be33eb8c" => :high_sierra
    sha256 "0cc199e14297b5ac81caf564bc6c9a7571e361cf49a445fa5dfa106745a8cf5e" => :sierra
    sha256 "01cf8d7ae7591ee285e0eef4a3ec651fab6bea95d32f7dd9143a90e319e583c2" => :el_capitan
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
