class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.12.tar.gz"
  sha256 "f51392ef4b55618b95a1e3859555c92879a7cd09dd4736e5b091a7fee392d9d4"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e0f229450772537ce4a7aaba3f08ddac8d2d825905a8a1118e6eb46ba06a5f0" => :sierra
    sha256 "05c18ecaa3de91ae186f19c5c85958d8e8dd8a8e0354f154aaae1c551203d8c8" => :el_capitan
    sha256 "e65242bb07c2f607aeb2bda4546eb51e85b5b7f9c6d4f91c3f26495a8696ddde" => :yosemite
    sha256 "b96e3da3b99e4ad8b3ac283acb6923c234af07f011a0b47cfc0a270af1999135" => :mavericks
  end

  head do
    url "git://thyrsus.com/repositories/src.git"
    depends_on "asciidoc" => :build
  end

  conflicts_with "srclib", :because => "both install a 'src' binary"

  depends_on "rcs"

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
