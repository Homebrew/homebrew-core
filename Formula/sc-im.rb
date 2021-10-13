class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/v0.8.2.tar.gz"
  sha256 "7f00c98601e7f7709431fb4cbb83707c87016a3b015d48e5a7c2f018eff4b7f7"
  license "BSD-4-Clause"
  revision 2
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    sha256 arm64_big_sur: "4c61408b90b2b5585279e8d19c24028ba13f6f5073589144fc71ae235c25ee2e"
    sha256 big_sur:       "3e73faa966c9b00428d60b741d88e66a64dbe0bd5943145b8f65b75a4172c8ba"
    sha256 catalina:      "bf2a132b303dac493a252b4668796bb27d608e76eeafe4a1f40b01517c5d35cf"
    sha256 mojave:        "ff69fd16113c4e1b85b47275b78d6398bdeaece2afea1db41ca61ab7865c1fbd"
    sha256 x86_64_linux:  "130eea9e4e62fd9c0c161dec373a5039f2bcf5c639a2cf13ae66edfee0a324f4"
  end

  depends_on "libxlsxwriter"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "ncurses"

  uses_from_macos "bison" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "src" do
      system "make", "prefix=#{prefix}"
      system "make", "prefix=#{prefix}", "install"
    end
  end

  test do
    input = <<~EOS
      let A1=1+1
      recalc
      getnum A1
    EOS
    output = pipe_output(
      "#{bin}/sc-im --nocurses --quit_afterload 2>/dev/null", input
    )
    assert_equal "2", output.lines.last.chomp
  end
end
