class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview"
  homepage "https://saldl.github.io/"
  url "https://github.com/saldl/saldl/archive/v40.tar.gz"
  sha256 "1cb7950848517fb82ec39561bf36c8cbc0a0caf8fa85355a5b76cac0281346ce"
  revision 1
  head "https://github.com/saldl/saldl.git", :shallow => false

  bottle do
    cellar :any
    sha256 "1ee6fb03ae4d6f8268cbf63452d56657b3801bf98318d8d2877740401ce85707" => :mojave
    sha256 "334bdb4450ab3325ad0b4d308a1b59ca452312335caee4f4a96a7258e523f266" => :high_sierra
    sha256 "abfa30ca15849b2cc4a4ad592acef5123a736a0589f74a0719a0f61d4bcc9b85" => :sierra
    sha256 "92835135c56b58d1902bc181e678d75e7175969894957ad67bdedcbf1b3059cc" => :el_capitan
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
