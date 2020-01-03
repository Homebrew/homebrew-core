class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps.git",
      :tag      => "v3.3.16",
      :revision => "59c88e18f29000ceaf7e5f98181b07be443cf12f"
  head "https://gitlab.com/procps-ng/procps.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0955d44620cfbbd8b191649a4924cd1526f10e786929c036caff0de1258c0c1" => :catalina
    sha256 "bdb4f8a1feed527be937eb0f470444c93643b3dc72943387fcd7584c2b96baf6" => :mojave
    sha256 "9fceef6cae551481726f86f9a0e5e79ca2bf27e0f41d0feb0800ab25e9161342" => :high_sierra
    sha256 "010375a88535763436571b3140bacd5733e8176621d663464a8ae3c57ed7813f" => :sierra
    sha256 "d89d82028efa1586bd6f6b05fba3f7c15259e6a9fedffa5e36d8a900514b0ecb" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "ncurses"

  conflicts_with "visionmedia-watch"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-nls",
                          "--enable-watch8bit"
    system "make", "watch"
    bin.install "watch"
    man1.install "watch.1"
  end

  test do
    system bin/"watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end
