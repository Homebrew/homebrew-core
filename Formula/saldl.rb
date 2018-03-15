class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview"
  homepage "https://saldl.github.io/"
  url "https://github.com/saldl/saldl/archive/v39.tar.gz"
  sha256 "88a7c2d1214d93dab739568180968723086814534207ade4736b2a5d4b53f29d"

  head "https://github.com/saldl/saldl.git", :shallow => false

  bottle do
    cellar :any
    sha256 "e188e80c260dd4c39e344753c5f6c622cbcc0ba4d32511339d79654cf58949a3" => :high_sierra
    sha256 "cc682cbf7b8bd1ce35fbb2159fb8ecf7d944a8294e009d87ef0aebae3325e4e0" => :sierra
    sha256 "1b5b1475bdc488b716f7cfcd0113ea66264a41e34853adfb5b89051dc9b2c1fc" => :el_capitan
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
