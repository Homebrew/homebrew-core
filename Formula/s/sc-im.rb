class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "5568f9987b6d26535c0e7a427158848f1bc03d829f74e41cbcf007d8704e9bd3"
  license "BSD-4-Clause"
  revision 1
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "30c124461f7951c735ff3229ddd618efe7e0ee3d612c2598f6165bb81bb96a24"
    sha256 arm64_ventura:  "54ae7f589b0c22177d4cdf1413ab1d86a487851848a4c81ce8f9280d95a46a7b"
    sha256 arm64_monterey: "9226b60d68226ee16f5fb30eff65a2d2d2c822e683b3bdf847c65f6454ffcdd8"
    sha256 sonoma:         "c7fdf013f4a21416ab555cdb6b62858e97231ef8d56ca00a46b3520c62d38db7"
    sha256 ventura:        "4bb402c6e5f62a0f0dca64f2657db17ada1e2a4c6786f000613b0f60101cffc5"
    sha256 monterey:       "8de79452a1c8e48f6d998d21534bd2604f823b41ed56fd149bfbb7605159526c"
    sha256 x86_64_linux:   "cb9262b8fed2322e7bcafe6bd0ed348e1dcca53667583c32a12a32d5b0113cf2"
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
