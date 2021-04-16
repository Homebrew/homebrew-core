class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/v0.8.1.tar.gz"
  sha256 "73958f2adf2548be138f90a1fa2cb3a9c316a6d8d78234ebb1dc408cbf83bac7"
  license "BSD-4-Clause"
  head "https://github.com/andmarti1424/sc-im.git", branch: "freeze"

  bottle do
    sha256 arm64_big_sur: "892bdf2037d8a344f8b254fbe43268a7cf3ed2309b5c43560261b17d9dca7759"
    sha256 big_sur:       "e50fc96b8e339bcad23a9c9e67beebc9aa4657a98d3acd9d7f3917090f80780e"
    sha256 catalina:      "8524932993aa6195a7fa6627c40dc477d32b5fc66839c95b5d5273abd6650f18"
    sha256 mojave:        "4477325a85962aba8dacce2082179bfa096f220f622b9c9b3af1d37d0e287e13"
  end

  depends_on "ncurses"

  def install
    cd "src" do
      system "make", "prefix=#{prefix}"
      system "make", "prefix=#{prefix}", "install"
    end
  end

  test do
    input = <<~EOS
      let A1=1+1
      getnum A1
    EOS
    output = pipe_output(
      "#{bin}/sc-im --nocurses --quit_afterload 2>/dev/null", input
    )
    assert_equal "2", output.lines.last.chomp
  end
end
