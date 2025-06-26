class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "49adb76fc55bc3e6ea8ee414f41428db4aef947e247718d9210be8d14a6524bd"
  license "BSD-4-Clause"
  revision 1
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "df975f182b5eab09c2d5a49e1b9c8fd56c0d44032b4ce251175b13cb15ca87dd"
    sha256 arm64_sonoma:  "4c7b41b070f198f566a737bde07f2e6d09d1e72df6e5365dc7985e1bf5b046ab"
    sha256 arm64_ventura: "66ed9adb30742165f893a2e5adeeb1edfecf18ed6e4c4ea4c32f948f7fd57efe"
    sha256 sonoma:        "f06d0a80eada71abafe7fab5f64916adf4253a1517b3e4d0ae529a3ff25d7bf5"
    sha256 ventura:       "dc9e91bbfe54d8969e72175182e3271d9ed85b22e5e5c8416be4bfad433d5696"
    sha256 arm64_linux:   "d777c8ccd3dd2bba6fdfb33d13b3e2b038ff76f016b38e83510cd4bec61017e9"
    sha256 x86_64_linux:  "c1f78593e30404a3f0201071e03d15bfc1efde780701e34c213fb6a40ac97b1c"
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
