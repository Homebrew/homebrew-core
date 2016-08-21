class Rfcdiff < Formula
  desc "Compare RFC Internet Draft versions"
  homepage "https://tools.ietf.org/tools/rfcdiff/"
  url "https://tools.ietf.org/tools/rfcdiff/rfcdiff-1.45.tgz"
  sha256 "82e449b7ee887074302b2050e41fc60d4b3bbec8c20e05ce2d7fab81b332771e"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3462b3abea27352f99c479a07a5e2aa73dd34435a691684770e407fcc3b48ee" => :el_capitan
    sha256 "590587076415e6d76a0c352a903bee09dda664529fe3b6bb15d3ea825e66d44a" => :yosemite
    sha256 "4a4b87ede364af23c406b53ec20e4729168363513c8ccc455f359bdde5bc120f" => :mavericks
    sha256 "8473a25840800f44a284dc498966abca18cf41687fce0b101982e6dbd89952e4" => :mountain_lion
  end

  depends_on "wdiff"
  depends_on "gawk" => :recommended
  depends_on "txt2man" => :build
  depends_on "gnu-sed" => :build

  resource "rfc42" do
    url "https://tools.ietf.org/rfc/rfc42.txt"
    sha256 "ba2c826790cae67eb7b4f4ff0f8fe608f620d29f789969c06abbc8da696c8e35"
  end

  resource "rfc43" do
    url "https://tools.ietf.org/rfc/rfc43.txt"
    sha256 "b6fc6c8e185ef122f3a2b025f9e66a5f4242bdec789d2e467c07bbcfef4deebb"
  end

  def install
    ENV.prepend_path "PATH", "#{Formula["gnu-sed"].opt_libexec}/gnubin"

    # replace hard-coded paths
    inreplace "Makefile.common", "/usr/share/man/man1", man1

    bin.mkpath
    man1.mkpath

    system "make", "-f", "Makefile.common",
                   "tool=rfcdiff",
                   "sources=rfcdiff.pyht",
                   "prefix=#{prefix}",
                   "install"
  end

  test do
    testpath.install resource("rfc42"), resource("rfc43")
    system "#{bin}/rfcdiff", "rfc42.txt", "rfc43.txt"
  end
end
