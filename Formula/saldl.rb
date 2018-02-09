class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview"
  homepage "https://saldl.github.io/"
  url "https://github.com/saldl/saldl/archive/v39.tar.gz"
  sha256 "88a7c2d1214d93dab739568180968723086814534207ade4736b2a5d4b53f29d"

  head "https://github.com/saldl/saldl.git", :shallow => false

  bottle do
    cellar :any
    sha256 "d3c6509e52bf9285cb8e8673d29e7ae671d6fb7f812ee5aaaec62eee1831648f" => :high_sierra
    sha256 "437f3c26942a1c2cc669bbfab19aaa74bdfd0fabedbaef4563ffa00e9349b6e8" => :sierra
    sha256 "1d7b2baa2218ae0b2d5369ab70aff8c312b838038c67ee6d0597051e5ca00875" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "curl" # curl >= 7.55 is required
  depends_on "libevent"

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
    system "#{bin}/saldl", "https://brew.sh/index.html"
    assert_predicate testpath/"index.html", :exist?
  end
end
