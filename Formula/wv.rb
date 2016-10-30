class Wv < Formula
  desc "Programs for accessing Microsoft Word documents"
  homepage "http://wvware.sourceforge.net/"
  url "http://abisource.com/downloads/wv/1.2.9/wv-1.2.9.tar.gz"
  sha256 "4c730d3b325c0785450dd3a043eeb53e1518598c4f41f155558385dd2635c19d"

  bottle do
    sha256 "b9ae25d64690436f441057dfa9aa3789deed460c743b3444642eefff761c76f5" => :sierra
    sha256 "9b9e70a5e3bb7e6d29c5af4eed803a7fcbe31df03deafaf35cba1cfc949f35fa" => :el_capitan
    sha256 "9924b96a1c67c774976b40de2083717a833d4dcaf801fba100f98677af01051c" => :yosemite
    sha256 "5076c41e62ea86c638b482904ca0e30cffb2cbd3eb3acfe7b105cb4b28766838" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgsf"
  depends_on "libwmf"
  depends_on "libpng"

  def install
    ENV.libxml2
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.deparallelize
    # the makefile generated does not create the file structure when installing
    # till it is fixed upstream, create the target directories here.
    # http://www.abisource.com/mailinglists/abiword-dev/2011/Jun/0108.html

    bin.mkpath
    (lib/"pkgconfig").mkpath
    (include/"wv").mkpath
    man1.mkpath
    (share/"wv/wingdingfont").mkpath
    (share/"wv/patterns").mkpath

    system "make", "install"
  end
end
