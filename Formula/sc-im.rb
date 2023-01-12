class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/v0.8.3.tar.gz"
  sha256 "5568f9987b6d26535c0e7a427158848f1bc03d829f74e41cbcf007d8704e9bd3"
  license "BSD-4-Clause"
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "b9bed9c5643e42a5a273233363c3e60f2d72011a8c4b5c5c48ba2f9793d7f231"
    sha256 arm64_monterey: "78cc3d96a88e383af5b41e821bc14144cd96e942f16b00d8a5f9e61d54a166d3"
    sha256 arm64_big_sur:  "c5d5f0345e2758ac7a52483e3426e44df0c9624de3bc35beb23b263df2919c77"
    sha256 ventura:        "a9f302b8b8d472a01407faed5aa2088e82ebd0901c2b91c1571762cf64cabb55"
    sha256 monterey:       "9bf17a880948c1fb8e1854a77f4837c7e0deaa1ac7e63a7f2284361553d0c96b"
    sha256 big_sur:        "6b721c653f3c6d4b047d833a3a21cebc4e79b40ce0f1b8d6622f84fead636481"
    sha256 x86_64_linux:   "c609d6e11270e9cd3f4cc9ff7284cfa638594a2c464a0ae9f73a687fada47838"
  end

  depends_on "pkg-config" => :build
  depends_on "libxls"
  depends_on "libxlsxwriter"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "lua"
  depends_on "ncurses"

  uses_from_macos "bison" => :build

  def install
    # Enable plotting with `gnuplot` if available.
    ENV.append_to_cflags "-DGNUPLOT"

    cd "src" do
      inreplace "Makefile" do |s|
        # Increase `MAXROWS` to the maximum possible value.
        # This is the same limit that Microsoft Excel has.
        s.gsub! "MAXROWS=65536", "MAXROWS=1048576"
        if OS.mac?
          # Use `pbcopy` and `pbpaste` as the default clipboard commands.
          s.gsub!(/^CFLAGS.*(xclip|tmux).*/, "#\\0")
          s.gsub!(/^#(CFLAGS.*pb(copy|paste).*)$/, "\\1")
        end
      end
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
