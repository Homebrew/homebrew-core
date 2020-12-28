class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.28.tar.gz"
  sha256 "ee448f17e0de07eed749188bf2b977211fc609314b079ebe6c23485ac72f79ba"
  license "BSD-2-Clause"

  head do
    url "https://gitlab.com/esr/src.git"
    depends_on "asciidoc" => :build
  end

  livecheck do
    url :homepage
    regex(/href=.*?src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5485c642c815e0368ace75c43907ece44ed6b220484be136ea791ad14780ee30" => :big_sur
    sha256 "6d72e26032c8eaf0416c285a84a3556e31d6a1ed962051aa254418f28d8b493d" => :arm64_big_sur
    sha256 "312d165d1840e28a6c33df33248a7236dc2c524ee792b575b2774afe5597e446" => :catalina
    sha256 "312d165d1840e28a6c33df33248a7236dc2c524ee792b575b2774afe5597e446" => :mojave
    sha256 "312d165d1840e28a6c33df33248a7236dc2c524ee792b575b2774afe5597e446" => :high_sierra
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
