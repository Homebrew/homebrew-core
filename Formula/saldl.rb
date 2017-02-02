class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview."
  homepage "https://saldl.github.io"
  url "https://github.com/saldl/saldl/archive/v35.tar.gz"
  sha256 "6b5f45a8f7782bcad124df4a24876c8b3c47d45aa25d0b09b2030837c6ece82c"

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
