class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v0.0.6.65.tar.gz"
  sha256 "17d4e386225e0a1cefed889d1fcd8512ef7ba02091bc4bd4729330eed9c1b0f8"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "4683e6006f178ca05952a9df4141a2d1c55cd4edb71a65f503d1b632ad62e930" => :el_capitan
    sha256 "f02272e1b180fe416b5dc1f5c8a50030a53ba016360f664bd13bde2535358edb" => :yosemite
    sha256 "6076a32dfe83af837a90b7d6f0f9ed6405a52402a24ace615f6fcd21d78da6a0" => :mavericks
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
