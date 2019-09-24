class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.27.tar.gz"
  sha256 "7d587db28dbdaf644b9aaf6b1bb63d067e7db9410042ef76fdf492023d9bc41c"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ec8ababc34fa8abf7605cae18a22a67c97f8e8b322be6b983a41a1da9abb195" => :mojave
    sha256 "7ec8ababc34fa8abf7605cae18a22a67c97f8e8b322be6b983a41a1da9abb195" => :high_sierra
    sha256 "bccf5dd779b311958ce56f2ac2837b7226dc5e4aa8bfdb1c04e51688a9286107" => :sierra
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
    require "pty"
    (testpath/"test.txt").write "foo"
    PTY.spawn("sh", "-c", "#{bin}/src commit -m hello test.txt; #{bin}/src status test.txt") do |r, _w, _pid|
      assert_match /^=\s*test.txt/, r.read
    end
  end
end
