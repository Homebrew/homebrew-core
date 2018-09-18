class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v18.9.10.94.tar.gz"
  sha256 "dcb98b9b71f228ee8c35d18a40c703badf697fd04d3ff50d5e09871027b9d02e"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "03da19c6b3da7fb306a452883766df632d67f44bae7089942d0ecba403603447" => :mojave
    sha256 "8a24e1f43ba4e03eb024b265ca8cb397a7b038b0c33d73a8e450a7dbe9a7522a" => :high_sierra
    sha256 "53d4e0a340c25dfe3e9f9c1a561c776cb4bdfc99aaa9fbdc2e2e4ea22f4373c0" => :sierra
    sha256 "7d02edc8fc078f3fa09194a9b11081d1082835f29f513d31280341636a1332d4" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

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
