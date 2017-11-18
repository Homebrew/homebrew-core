class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.17.tar.gz"
  sha256 "1362068b46c035a8d19cafd12e3b23b8251c667bd98242f9c7b05b842f2c089d"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e661eebff98f474fbc7a362da628b4369b9ae9e46b215288cbf37d21265a734" => :high_sierra
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
