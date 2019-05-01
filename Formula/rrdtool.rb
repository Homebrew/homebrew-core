class Rrdtool < Formula
  desc "Round Robin Database"
  homepage "https://oss.oetiker.ch/rrdtool/index.en.html"
  url "https://github.com/oetiker/rrdtool-1.x/releases/download/v1.7.1/rrdtool-1.7.1.tar.gz"
  sha256 "989b778eda6967aa5192c73abafe43e7b10e6100776971a7e79d249942781aae"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1059ba04ca08cf52d7eb4d4327e0d531d751ab8e43f78daa9a4141f78f7264ae" => :mojave
    sha256 "5ef3f96dffc6ff002feea4d89eadf80a16f9d39f86ec2096600fbbeb229f9c0d" => :high_sierra
    sha256 "d83b25d91e82350f92041e001fa0652c05198df9490323f6c9582028fde4ea5b" => :sierra
  end

  head do
    url "https://github.com/oetiker/rrdtool-1.x.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "pango"
  depends_on "perl"

  def install
    # fatal error: 'ruby/config.h' file not found
    ENV.delete("SDKROOT")

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-tcl
      --with-tcllib=/usr/lib
      --with-perl-options='PREFIX=#{prefix}'
      --enable-ruby-site-install
    ]

    # Ha-ha, but sleeping is annoying when running configure a lot
    inreplace "configure", /^sleep 1$/, "#sleep 1"

    system "./bootstrap" if build.head?
    system "./configure", *args

    # Needed to build proper Ruby bundle
    ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"

    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}", "install"
    prefix.install "bindings/ruby/test.rb"
  end

  test do
    system "#{bin}/rrdtool", "create", "temperature.rrd", "--step", "300",
      "DS:temp:GAUGE:600:-273:5000", "RRA:AVERAGE:0.5:1:1200",
      "RRA:MIN:0.5:12:2400", "RRA:MAX:0.5:12:2400", "RRA:AVERAGE:0.5:12:2400"
    system "#{bin}/rrdtool", "dump", "temperature.rrd"
  end
end
