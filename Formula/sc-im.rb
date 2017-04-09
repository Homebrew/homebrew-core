class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/v0.5.0.tar.gz"
  sha256 "d7a31c5225e02239e925b50b414d7e69d12bc3554f218621823782872ccc5e4d"
  head "https://github.com/andmarti1424/sc-im.git", :branch => "freeze"

  depends_on "ncurses"

  def install
    ENV.prepend "LDFLAGS", "-L#{Formula["ncurses"].opt_lib}"

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
      "#{bin}/scim --nocurses --quit_afterload", input, 0
    )
    assert_equal "nowide 2", output.lines.last.chomp
  end
end
