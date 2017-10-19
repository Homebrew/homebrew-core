class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/v0.6.0.tar.gz"
  sha256 "5da644d380ab3752de283b83cce18c3ba12b068d0762c44193c34367a0dcbc38"
  head "https://github.com/andmarti1424/sc-im.git", :branch => "freeze"

  bottle do
    sha256 "077da2cd3c11e733b98e001a0399d60bf4692bb77da4788ea10b1e1c7492bebe" => :high_sierra
    sha256 "52537994a6624c403e51686d25b95c069678bfff060b6cd641e1d821791889b5" => :sierra
    sha256 "b7b86baf81055e52762736acdd5b2f22985e160e66e231d424d1f99452008f6a" => :el_capitan
  end

  depends_on "ncurses"

  def install
    cd "src" do
      system "make", "prefix=#{prefix}"
      system "make", "prefix=#{prefix}", "install"
    end
  end

  test do
    input = <<-EOS.undent
      let A1=1+1
      getnum A1
    EOS
    output = pipe_output(
      "#{bin}/scim --nocurses --quit_afterload 2>/dev/null", input
    )
    assert_equal "nowide 2", output.lines.last.chomp
  end
end
