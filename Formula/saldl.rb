class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview."
  homepage "https://saldl.github.io/"
  url "https://github.com/saldl/saldl/archive/v35.tar.gz"
  sha256 "6b5f45a8f7782bcad124df4a24876c8b3c47d45aa25d0b09b2030837c6ece82c"

  head "https://github.com/saldl/saldl.git", :shallow => false

  bottle do
    cellar :any
    sha256 "723d7e0181ea35f4b6643682db7731434411454239ef7c61a9393cd8cf5c9a08" => :sierra
    sha256 "f006aa31bd31f9410a5579a92354c3d4acba5a7ac2102564423120ba1b45ef06" => :el_capitan
    sha256 "689d5ea91227117ad5c43d52925456a8e75b069e4900a15a5853a6de96b8ffd5" => :yosemite
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
    system "#{bin}/saldl", "https://brew.sh/index.html"
    assert File.exist? "index.html"
  end
end
