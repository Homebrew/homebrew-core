class Rrdtool < Formula
  desc "Round Robin Database"
  homepage "https://oss.oetiker.ch/rrdtool/"
  license "GPL-2.0-only"
  revision 1

  stable do
    url "https://github.com/oetiker/rrdtool-1.x/releases/download/v1.9.0/rrdtool-1.9.0.tar.gz"
    sha256 "5e65385e51f4a7c4b42aa09566396c20e7e1a0a30c272d569ed029a81656e56b"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end

    # fix HAVE_DECL checks, upstream pr ref, https://github.com/oetiker/rrdtool-1.x/pull/1262
    patch do
      url "https://github.com/oetiker/rrdtool-1.x/commit/98b2944d3b41f6e19b6a378d7959f569fdbaa9cd.patch?full_index=1"
      sha256 "86b2257fcd71072b712e7079b3fed87635538770a7619539eaa474cbeaa8b7f5"
    end
  end

  bottle do
    sha256 arm64_tahoe:   "af31da27f499a6c45e9a953ace7433b4426257f79c4662a3e34b3db176d7ec6b"
    sha256 arm64_sequoia: "8211f623d3574a49017217e53cb5ea478c2c70a66e9db9f05a33bfc5cc5916c3"
    sha256 arm64_sonoma:  "60537031ef479b3cb9c99ab8ced2a06586261178747c913b40741e975ece33bc"
    sha256 sonoma:        "06c7e707f676165b56680e9dfd99afddf8af115c8d49d49c5d4903c39b92f283"
    sha256 arm64_linux:   "fb254e1c08da875dc69e36c8d88ac48e833255e5e23d24ae1dcb6fdd28fe127d"
    sha256 x86_64_linux:  "bd73a9c1a9d2374168a12dc6eb7d283a086e39769ca400cf0763c9b68e725c31"
  end

  head do
    url "https://github.com/oetiker/rrdtool-1.x.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
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
