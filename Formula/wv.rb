class Wv < Formula
  desc "Programs for accessing Microsoft Word documents"
  homepage "https://wvware.sourceforge.io/"
  url "https://abisource.com/downloads/wv/1.2.9/wv-1.2.9.tar.gz"
  sha256 "4c730d3b325c0785450dd3a043eeb53e1518598c4f41f155558385dd2635c19d"

  bottle do
    sha256 "ccef7d779d4138475c9eea9d0e1e6174787c79f6ab244327b86a40c76c1a7acc" => :mojave
    sha256 "66081b31ef3906844afa215ad038f80b353bd49bb36f075c0fd5ce4951cd68cd" => :high_sierra
    sha256 "b9ae25d64690436f441057dfa9aa3789deed460c743b3444642eefff761c76f5" => :sierra
    sha256 "9b9e70a5e3bb7e6d29c5af4eed803a7fcbe31df03deafaf35cba1cfc949f35fa" => :el_capitan
    sha256 "9924b96a1c67c774976b40de2083717a833d4dcaf801fba100f98677af01051c" => :yosemite
    sha256 "5076c41e62ea86c638b482904ca0e30cffb2cbd3eb3acfe7b105cb4b28766838" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgsf"
  depends_on "libpng"
  depends_on "libwmf"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.deparallelize
    # the makefile generated does not create the file structure when installing
    # till it is fixed upstream, create the target directories here.
    # https://www.abisource.com/mailinglists/abiword-dev/2011/Jun/0108.html

    bin.mkpath
    (lib/"pkgconfig").mkpath
    (include/"wv").mkpath
    man1.mkpath
    (pkgshare/"wingdingfont").mkpath
    (pkgshare/"patterns").mkpath

    system "make", "install"
  end
end
