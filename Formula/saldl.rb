class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview."
  homepage "https://saldl.github.io"
  url "https://github.com/saldl/saldl/archive/v34.tar.gz"
  sha256 "12053f306306023e5bbdc6bb8594cc83f8793da0ce99dab1981179cdeccea4da"
  revision 1

  head "https://github.com/saldl/saldl.git", :shallow => false

  bottle do
    cellar :any
    sha256 "0b6424d6057b2c1780acc2f279de125627fa1eab22b1506a20be2db029d8a451" => :sierra
    sha256 "328c65d4a6028a7ee7e519d8c2ff4b3c304904454ec22dc7fb2d4a5e8d20ec7b" => :el_capitan
    sha256 "bde0f91712ff7a394c667869f098551e14a216ca56805e0b2b0b28dbf404cd18" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libevent"

  if MacOS.version <= :mavericks
    # curl >= 7.42 is required
    depends_on "curl"
  else
    depends_on "curl" => :optional
  end

  def install
    ENV.refurbish_args

    # a2x/asciidoc needs this to build the man page successfully
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Fixes clock_gettime build error on macOS 10.11
    # Reported 28 January 2017 https://github.com/saldl/saldl/issues/8
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "wscript", "clock_gettime(CLOCK_MONOTONIC_RAW, &tp);",
                           "not_a_function(NOT_A_SYMBOL, &tp);"
    end

    args = ["--prefix=#{prefix}"]

    # head uses git describe to acquire a version
    args << "--saldl-version=v#{version}" unless build.head?

    system "./waf", "configure", *args
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system "#{bin}/saldl", "http://brew.sh/index.html"
    assert File.exist? "index.html"
  end
end
