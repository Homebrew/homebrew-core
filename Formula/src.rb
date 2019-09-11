class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.26.tar.gz"
  sha256 "435c457f9f577d84ae1fd763e2bd3548d84f84c50cd2c88f664fba259cd5d71a"

  bottle do
    cellar :any_skip_relocation
    sha256 "302170e0a42b5e3351325edd7781100a383a1f15e72ad2adf00748f6f648867a" => :mojave
    sha256 "302170e0a42b5e3351325edd7781100a383a1f15e72ad2adf00748f6f648867a" => :high_sierra
    sha256 "02ff17c0ea729ab844c15fa034b173bae533cd6e3471e2315d163eeee19a8670" => :sierra
  end

  head do
    url "https://gitlab.com/esr/src.git"
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
