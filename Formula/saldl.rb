class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview."
  homepage "https://saldl.github.io/"
  url "https://github.com/saldl/saldl/archive/v36.tar.gz"
  sha256 "922efd422f32b4b0cec350933257920b196780dfef1727a72e8a2933f8b7b444"

  head "https://github.com/saldl/saldl.git", :shallow => false

  bottle do
    cellar :any
    sha256 "51f9b200ce0f93749b8e7fd66c7c8985f3b6fd14ca32bafc57b9c83a37ef4664" => :sierra
    sha256 "93737eb942258a0b35944347ebc70d362dd2d8cdcb47e88fed89217df2cc7b4a" => :el_capitan
    sha256 "ad37aabeb7277950a137f2482ddfbe424676c5513691c65bb569725b3e09a3f0" => :yosemite
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
