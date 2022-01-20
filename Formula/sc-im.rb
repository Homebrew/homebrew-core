class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/v0.8.2.tar.gz"
  sha256 "7f00c98601e7f7709431fb4cbb83707c87016a3b015d48e5a7c2f018eff4b7f7"
  license "BSD-4-Clause"
  revision 4
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "5bebafdb76dd401671b0b1888f3db8b2e6c8e4c79af6d5beb26796f62848f5e1"
    sha256 arm64_big_sur:  "b055d6cf9eef6bf5c975a1eb6919875580f2014bcfb73cb333f650e940f9d6a4"
    sha256 monterey:       "6e9c2d8b686b95f3f5814a6892a5552f40ce2008977741937a4b8d2845c34868"
    sha256 big_sur:        "7e830a488a3d2645044fdab8494e1497c37dd4b72933dc6a638948b7f5c2c6c7"
    sha256 catalina:       "1c62ae56ea50617ef67e0363d7b99ffc83eb7ec1688d74ccf44142ec5bba6811"
    sha256 x86_64_linux:   "1be8f9b8c792d4203ebdd6021915ff23dc1c9e39749cff724f435df9c7bfb44a"
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
