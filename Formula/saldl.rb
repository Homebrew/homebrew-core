class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview"
  homepage "https://saldl.github.io/"
  url "https://github.com/saldl/saldl/archive/v40.tar.gz"
  sha256 "1cb7950848517fb82ec39561bf36c8cbc0a0caf8fa85355a5b76cac0281346ce"
  revision 1
  head "https://github.com/saldl/saldl.git", :shallow => false

  bottle do
    cellar :any
    sha256 "7fd875e38f9506d4ca5cca0e14815cea29ba40bf61385f53f93c8a587d5b50d3" => :mojave
    sha256 "1c2f3b014669b8a19a1f3be6f654d8c438e62d5ed64e2c72b4f54a33e0f67b88" => :high_sierra
    sha256 "7fbb71dbced4c48d0586f5f58fd4d64b87b39f4e3f78ad1188f11edb7c4af9a5" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
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
