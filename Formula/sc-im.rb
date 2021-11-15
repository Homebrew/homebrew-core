class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/v0.8.2.tar.gz"
  sha256 "7f00c98601e7f7709431fb4cbb83707c87016a3b015d48e5a7c2f018eff4b7f7"
  license "BSD-4-Clause"
  revision 3
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "7ebc2e0f8248b991474defdab0519dbffc74761b0627100abb9a52e15cc1f945"
    sha256 arm64_big_sur:  "7a695c6f3c7c830c2c88bf60ec0bc8e844a82b1adf7ed4cd474d89326c0600ff"
    sha256 monterey:       "16d81d91ba10cc86b39c3408290a3dfc71458c0e72b9dce4bf0dde9a817600f6"
    sha256 big_sur:        "311253002c6a2e14f2003a7e7e8f88ecbe54a7bd6f373a695e14a2cb4ec0a377"
    sha256 catalina:       "d25892c33ee8ac59c5e6439a9fe7893fa49c4a8514c2aac880f95f997c3eef32"
    sha256 x86_64_linux:   "cfcf853d84da9ede68d92fed791600c887869a2fcb2c689eafb3f491a00b06af"
  end

  depends_on "libxls"
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
