class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.12.tar.gz"
  sha256 "f51392ef4b55618b95a1e3859555c92879a7cd09dd4736e5b091a7fee392d9d4"

  bottle do
    cellar :any_skip_relocation
    sha256 "d50a826530e965755f761ceb874c6a3a2044fdecc7af29894ceee56e6f0e9fa7" => :sierra
    sha256 "f698243fd5a6114de9792c89b37037237b41d4b002b840ed6d39b97d2c447989" => :el_capitan
    sha256 "d50a826530e965755f761ceb874c6a3a2044fdecc7af29894ceee56e6f0e9fa7" => :yosemite
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
