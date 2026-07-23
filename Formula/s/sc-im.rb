class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "49adb76fc55bc3e6ea8ee414f41428db4aef947e247718d9210be8d14a6524bd"
  license "BSD-4-Clause"
  revision 4
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "1cc0a6f1c2ceaed2882bdfc320acff02e3aeca823226cffad9f9b53e5184d206"
    sha256 arm64_sequoia: "6ca2186448913062e28c3304d76e7c8394b590c4a5452f7d7262dd4abf9c3fda"
    sha256 arm64_sonoma:  "01c63cfb4dd104e85ba0c9bd08aaa3e603b07dfff6eb307723e56b402d3aaa5c"
    sha256 sonoma:        "9335efab4aba90b13bdef0d33547d82115a5f2ef08b1cfa3a2583bf10e7be3ca"
    sha256 arm64_linux:   "396e61cf946e7cf03a9f0712a9154589ca12bb6617f16b999e737988136a2a31"
    sha256 x86_64_linux:  "7c24185e644c1c3e654b8006f7aae4b9d62cfac6cac39f7b8d7dae27583bb43a"
  end

  depends_on "pkgconf" => :build
  depends_on "libxls"
  depends_on "libxlsxwriter"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "lua"
  depends_on "ncurses"

  uses_from_macos "bison" => :build

  def install
    # Workaround for Xcode 14.3
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

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
