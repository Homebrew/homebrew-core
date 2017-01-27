class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview."
  homepage "https://saldl.github.io"
  url "https://github.com/saldl/saldl/archive/v34.tar.gz"
  sha256 "12053f306306023e5bbdc6bb8594cc83f8793da0ce99dab1981179cdeccea4da"
  revision 1

  head "https://github.com/saldl/saldl.git", :shallow => false

  bottle do
    cellar :any
    rebuild 1
    sha256 "c018fd1c0c1d356c7e084a84865ef0bb14074f8ac578c12bf921f92ec2b2e7fa" => :sierra
    sha256 "8fcfee53034c79f680bdf8a4ef0cc9673f52dd5c6c9cf2b08caa4cf59cda8ba7" => :el_capitan
    sha256 "a1307b5bf28fafdf11c9164c5a9754a461bc9c87447e02a15eabb9b6ad40ac64" => :yosemite
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
