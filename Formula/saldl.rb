class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview."
  homepage "https://saldl.github.io/"
  url "https://github.com/saldl/saldl/archive/v37.tar.gz"
  sha256 "9e8f91d3c82366dd6a72b24ab4ceecd4328df8eb3bb3347cc1fde26bcda04aa8"

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
