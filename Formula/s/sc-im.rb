class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "49adb76fc55bc3e6ea8ee414f41428db4aef947e247718d9210be8d14a6524bd"
  license "BSD-4-Clause"
  revision 3
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "97af3758d3ac50f6aca92a8db079006c07c3eb92a87c36c025b6b3789ea3a7cc"
    sha256 arm64_sequoia: "1896d96ba98fdfcf184b505ed41dbd4823e291a64f1509b2d3c0877a6805d09d"
    sha256 arm64_sonoma:  "2be41accc7a0fce03920cd40ecc447442df4c820bd31b754bf22b19512430f8c"
    sha256 sonoma:        "a36947a4b9ad9a2ade3f721d2b3c02933064951581bdc644d76ad592e047169d"
    sha256 arm64_linux:   "5cb43731cc7347b0bd7081c50fa7e821cb8b7848cb85b5eec609ab540c318af7"
    sha256 x86_64_linux:  "fc293586c23f46badecc6f3efb8318bc0fe1d04541d46c9540564a3da15c5e5a"
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
