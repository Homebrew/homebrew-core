class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview"
  homepage "https://saldl.github.io/"
  url "https://github.com/saldl/saldl/archive/v38.tar.gz"
  sha256 "412dc8bdc65b44242438e3765d1cc61698759442962e1e5f3298068537bdc6a8"

  head "https://github.com/saldl/saldl.git", :shallow => false

  bottle do
    cellar :any
    sha256 "6c7151634d74ed35a6dff9c9b9c01e0099fa16ad823434805301cd51e2a3104c" => :high_sierra
    sha256 "e2b43d46455a439dc0a944b0dce104f37de07f46d2d92bca09cd39c90d880397" => :sierra
    sha256 "3aea3af9027e04dbd003a9e959d94cc347b334c6ff654b0fcd840b5733fc999b" => :el_capitan
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
