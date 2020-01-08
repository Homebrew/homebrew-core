class Rrdtool < Formula
  desc "Round Robin Database"
  homepage "https://oss.oetiker.ch/rrdtool/index.en.html"
  url "https://github.com/oetiker/rrdtool-1.x/releases/download/v1.7.2/rrdtool-1.7.2.tar.gz"
  sha256 "a199faeb7eff7cafc46fac253e682d833d08932f3db93a550a4a5af180ca58db"

  bottle do
    sha256 "a4d3e8bf312569dc26aca0b029ffcc297f6db4ebbef7d0317b02cf500d5cce28" => :catalina
    sha256 "222f77c78f4cf725543038d06d198a4c7c9f3fcfdc84b86b7db6b9d056baf10e" => :mojave
    sha256 "9c7bfeb5624aa4589c9e0894342e70ff4706b57628a0ed879d4e751146640ca3" => :high_sierra
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

  def install
    # fatal error: 'ruby/config.h' file not found
    ENV.delete("SDKROOT")

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-tcl
      --with-tcllib=/usr/lib
      --disable-perl-site-install
      --disable-ruby-site-install
    ]

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
