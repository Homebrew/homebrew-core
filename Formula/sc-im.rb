class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/v0.8.2.tar.gz"
  sha256 "7f00c98601e7f7709431fb4cbb83707c87016a3b015d48e5a7c2f018eff4b7f7"
  license "BSD-4-Clause"
  revision 4
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "6b7571347c91ff4f1d092eaa869c193aec2e5d21d297f1ea28f72503caf6c3e5"
    sha256 arm64_monterey: "1f124ca1348d233d34dfbd66d267ea410d0f278738cfe41d3d09c568869c8e6c"
    sha256 arm64_big_sur:  "a28c373e91d91fbaf19826326d1cdd7170f40db8783de0a11bdb8a2f5f821236"
    sha256 ventura:        "e0c11ef8dd205034ea16d8a4f104fb4afba2688ece863ef0d3cdccd63a35ecc9"
    sha256 monterey:       "6ced05dfc86a7785bf2b7d8e46c3a05df41bb7f344602d38fd0ae4eca88f1470"
    sha256 big_sur:        "0dccff5f3ba32682f1998a16b8c84413cc1934cbebe378959473f3eafa12a519"
    sha256 catalina:       "2d721b8f11810b2024c50e963f3c4ec4da4fe9d6480c41798af9c6d3c9312c5b"
    sha256 x86_64_linux:   "07756076e093423844a261a77f537844e122e1648db2acc0ae5ddba75ab42293"
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
