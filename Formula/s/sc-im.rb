class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "49adb76fc55bc3e6ea8ee414f41428db4aef947e247718d9210be8d14a6524bd"
  license "BSD-4-Clause"
  revision 1
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "7aba3a846b8467a016703a76d89d74adbc8dff5bf280bf2efdb74b606a3e9af3"
    sha256 arm64_sonoma:  "ae3adeb54d88c80a5145201b65ecf2636275d50eabb26e7e0ef6ef1549b71deb"
    sha256 arm64_ventura: "0c6b9e49eda65b7a772058a20a4db0706ee234f322f75b07eb8ca83d739c85a2"
    sha256 sonoma:        "3aba21c49aa83ab69c8357bfdb4c9d9e789bbbb0bc3a2cf019518f3ab5f37ebb"
    sha256 ventura:       "04b84b09e7caaff2ff0d41e673d1f061e465a9f2487e40819022d8975b9a160c"
    sha256 arm64_linux:   "2591a8c40e0ca1f1e2e44ceed406531af4a641fc05d8d4950f21481e874b51c0"
    sha256 x86_64_linux:  "a4d52f559c04305dcaeea5b9183df4a3dfd3b7175fc86e3222428693d704c72e"
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
