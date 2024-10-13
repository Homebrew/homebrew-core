class Rrdtool < Formula
  desc "Round Robin Database"
  homepage "https://oss.oetiker.ch/rrdtool/index.en.html"
  license "GPL-2.0-only"

  stable do
    url "https://github.com/oetiker/rrdtool-1.x/releases/download/v1.9.0/rrdtool-1.9.0.tar.gz"
    sha256 "5e65385e51f4a7c4b42aa09566396c20e7e1a0a30c272d569ed029a81656e56b"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end

    # fix HAVE_DECL checks, upstream pr ref, https://github.com/oetiker/rrdtool-1.x/pull/1262
    patch do
      url "https://github.com/oetiker/rrdtool-1.x/commit/98b2944d3b41f6e19b6a378d7959f569fdbaa9cd.patch?full_index=1"
      sha256 "86b2257fcd71072b712e7079b3fed87635538770a7619539eaa474cbeaa8b7f5"
    end
  end

  bottle do
    sha256 arm64_sequoia:  "204e4e8ca3d88f6808d1e370f4bf2614a2da964ae4b8b55b97edf837e4447cd4"
    sha256 arm64_sonoma:   "5068094067bf7166f46f60a410d8ec25f550b8bb4ec667c2d581efcfcf2b1526"
    sha256 arm64_ventura:  "d40dea08387b84b848a9142c1b48e0247312e80e29010e8c068b051ffc64b9a4"
    sha256 arm64_monterey: "37a3790cf1419f1d8b39baa4ff8e995b9e72f80ace0a289bdb3b5379e1764dc6"
    sha256 sonoma:         "e135bffca7c601ab3f539fa6c0a7d9756a20a20654b6e70acc01ac1238414f52"
    sha256 ventura:        "8b2a72bdffacc374a613ed17c3fa9966521b09f968e18799fca9c28ce350cc59"
    sha256 monterey:       "979b3fd513e67da16268a66997d3442a58c8716979fd8fa43996f51a05ab5de0"
    sha256 x86_64_linux:   "a7e81bcff828d14ddf9ca6759a9784a6d23c26ba667d52c967482848f563f4dc"
  end

  head do
    url "https://github.com/oetiker/rrdtool-1.x.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "libpng"
  depends_on "pango"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    args = %w[
      --disable-silent-rules
      --disable-lua
      --disable-perl
      --disable-python
      --disable-ruby
      --disable-tcl
    ]

    system "./bootstrap" if build.head?
    inreplace "configure", /^sleep 1$/, "#sleep 1"
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rrdtool", "create", "temperature.rrd", "--step", "300",
      "DS:temp:GAUGE:600:-273:5000", "RRA:AVERAGE:0.5:1:1200",
      "RRA:MIN:0.5:12:2400", "RRA:MAX:0.5:12:2400", "RRA:AVERAGE:0.5:12:2400"

    system bin/"rrdtool", "dump", "temperature.rrd"
  end
end
