class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "49adb76fc55bc3e6ea8ee414f41428db4aef947e247718d9210be8d14a6524bd"
  license "BSD-4-Clause"
  revision 5
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    manifest_sha256 "fbcc343041591f19fa59092426ff247a3d61bb1b49530d0853fd65ff2eb18a75"
    sha256 arm64_golden_gate: "4efbb68594acdb1bf6aae1bdf801188915118b1751a2ef78e1cc02defd072461"
    sha256 arm64_tahoe:       "21b2e372ffd18e6b1201f6f8e26d7f9f87f01bf5f410bf5b4c7758109afe479c"
    sha256 arm64_sequoia:     "4d1764c6deaeaf5235ea0049dddae62713a11db2ec2bdf33ba57f7fe02f58b78"
    sha256 arm64_linux:       "0b28980ae331b2557ee353aa0c59c0de36f4c39fb7f35befab1892c2c9c89029"
    sha256 x86_64_linux:      "c1c60cae8e4541eeac4f5b87dc583484e59976fc743edb766529b34aabf7a76b"
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
