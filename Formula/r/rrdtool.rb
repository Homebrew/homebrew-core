class Rrdtool < Formula
  desc "Round Robin Database"
  homepage "https://oss.oetiker.ch/rrdtool/"
  url "https://github.com/oetiker/rrdtool-1.x/releases/download/v1.11.0/rrdtool-1.11.0.tar.gz"
  sha256 "24c345b5c077c1b2b2fcbc1a364f1da051650fb6743ad5213096adc04c862ed4"
  license "GPL-2.0-or-later" => { with: "RRDtool-FLOSS-exception-2.0" }

  bottle do
    sha256 arm64_tahoe:   "5b5771f9ce22660d34ebf057b623c98f28074469d89740d325741eab55b8df39"
    sha256 arm64_sequoia: "043da3c2de7470fe44ee49730373e7bb40c12c62ed0158500c04e7c07d64ee51"
    sha256 arm64_sonoma:  "5f024d714cdec495210d9841181f6b8cf1dee01f30c538266c20060f9d392e28"
    sha256 sonoma:        "eb72757c3d6e43fb1f9f47d6848fb69491e066daf797beb5982d5d8160e5705e"
    sha256 arm64_linux:   "106515dd0c9596694f8047bfc337cef0718556f25185efe35e456ae62144feac"
    sha256 x86_64_linux:  "39d8fea0f86a2eec9202dc3abe1d6140e1eca8c00a0fdc6d3592285a801ef6b8"
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
