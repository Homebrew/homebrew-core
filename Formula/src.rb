class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.28.tar.gz"
  sha256 "ee448f17e0de07eed749188bf2b977211fc609314b079ebe6c23485ac72f79ba"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "273641371d813cdd5661bf1056e6aa671f3beb53b121e5197b75cd2751461fbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d72e26032c8eaf0416c285a84a3556e31d6a1ed962051aa254418f28d8b493d"
    sha256 cellar: :any_skip_relocation, monterey:       "273641371d813cdd5661bf1056e6aa671f3beb53b121e5197b75cd2751461fbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5485c642c815e0368ace75c43907ece44ed6b220484be136ea791ad14780ee30"
    sha256 cellar: :any_skip_relocation, catalina:       "312d165d1840e28a6c33df33248a7236dc2c524ee792b575b2774afe5597e446"
    sha256 cellar: :any_skip_relocation, mojave:         "312d165d1840e28a6c33df33248a7236dc2c524ee792b575b2774afe5597e446"
    sha256 cellar: :any_skip_relocation, high_sierra:    "312d165d1840e28a6c33df33248a7236dc2c524ee792b575b2774afe5597e446"
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
      assert_match(/^=\s*test.txt/, r.read)
    end
  end
end
