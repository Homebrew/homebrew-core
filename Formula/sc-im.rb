class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/v0.8.2.tar.gz"
  sha256 "7f00c98601e7f7709431fb4cbb83707c87016a3b015d48e5a7c2f018eff4b7f7"
  license "BSD-4-Clause"
  revision 2
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    sha256 arm64_big_sur: "fb1822b15198f453e30271bba682a99f691cc40d06a6b579c7a6f7dcc2d369c0"
    sha256 big_sur:       "73d779f46ea650c13122071a3ffe42c74c041ddc2cba44a7dfcffdf165675e54"
    sha256 catalina:      "27ba7d0efc18b31798bb241bb8715e3a27c12e85fb6d3d32d71d86d7f238033a"
    sha256 mojave:        "dfe4dcccf9298bfef23dbb5202ff4cc271146df186ce34b211d569bae8fe7f84"
    sha256 x86_64_linux:  "8bf0655f44d0c532ef10a05fc234361fd99dbea75919399f0cf5ca98d2718fae"
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
