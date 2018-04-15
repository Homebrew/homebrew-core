class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.18.tar.gz"
  sha256 "cc0897c1763f57e6627fd912a315de5554e4bb53fa0958c8578223e5379c1a58"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a26b02a324638430eb06dccc9ff797cc33d9e5fb0a1313357210a06246a9617" => :high_sierra
    sha256 "4a26b02a324638430eb06dccc9ff797cc33d9e5fb0a1313357210a06246a9617" => :sierra
    sha256 "4a26b02a324638430eb06dccc9ff797cc33d9e5fb0a1313357210a06246a9617" => :el_capitan
  end

  head do
    url "git://thyrsus.com/repositories/src.git"
    depends_on "asciidoc" => :build
  end

  depends_on "rcs"

  conflicts_with "srclib", :because => "both install a 'src' binary"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.head?

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.txt").write "foo"
    system "#{bin}/src", "commit", "-m", "hello", "test.txt"
    system "#{bin}/src", "status", "test.txt"
  end
end
