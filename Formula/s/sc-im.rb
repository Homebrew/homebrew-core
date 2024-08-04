class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "5568f9987b6d26535c0e7a427158848f1bc03d829f74e41cbcf007d8704e9bd3"
  license "BSD-4-Clause"
  revision 2
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "f9f568481eed1fd302e6d5e9a6a725321592592e41a05855dbd6b309e846a2c6"
    sha256 arm64_ventura:  "e8d68308be88793f9fc0ea408e814032875e086ce52a896e1d10d49972ba56fc"
    sha256 arm64_monterey: "e3f0394319f36348e8bd406647b0777564b91e245a88d34f90c140d08daee92b"
    sha256 sonoma:         "7f4bfbad3f53dea15be8f757eb4b6c2ab21dc8a2efc34dbc92c7f432ad47f931"
    sha256 ventura:        "84bdfad783a9ec314810accbfb16812c6e3e719a2bc13a9cd5b4f8b6cf6f77f8"
    sha256 monterey:       "a8e914cc8cef9c409d63fa341acd5423b88dee3d1a6d729d9ee01abaa649b547"
    sha256 x86_64_linux:   "90cd04bf0f03f557d56defb15ca0a44adb1159704e0e74105c4915491057fffd"
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
