class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.28.tar.gz"
  sha256 "ee448f17e0de07eed749188bf2b977211fc609314b079ebe6c23485ac72f79ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "cceb553982a4cc0f3fafa72f7bf6622f017915b45bc595e1d588082309e66acb" => :catalina
    sha256 "7ec8ababc34fa8abf7605cae18a22a67c97f8e8b322be6b983a41a1da9abb195" => :mojave
    sha256 "7ec8ababc34fa8abf7605cae18a22a67c97f8e8b322be6b983a41a1da9abb195" => :high_sierra
    sha256 "bccf5dd779b311958ce56f2ac2837b7226dc5e4aa8bfdb1c04e51688a9286107" => :sierra
  end

  head do
    url "https://gitlab.com/esr/src.git"
    depends_on "asciidoc" => :build
  end

  depends_on "rcs"

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
