class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "ebb1f10006fe49f964a356494f96d86a4f06eb018659e3b9bde63b25c03abdf0"
  license "BSD-4-Clause"
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    sha256 arm64_sequoia:  "7c0d1853ada3fe9bec1a41a9c847f652151495eed510d541ae3b599bcc32e1ad"
    sha256 arm64_sonoma:   "cbd1e873c3488d61e71d3d3f320f196be3b52a60b225a3cbd34bac86417fa867"
    sha256 arm64_ventura:  "3f7989b3e41a89308b432e6f8f7ce85ef2665899f6c628db9b27f11da9496dcd"
    sha256 arm64_monterey: "26e8c661c4ce9a3ef7f34f6050a7558eb6a9d6140aaa6620ce9ba71ebddffdd9"
    sha256 sonoma:         "f8fd4583452db9f3c10bbd37358d6bb0f605d7902d148e7da38528a8ebb54b53"
    sha256 ventura:        "cbfbccfcb5ca3ecc692e4f6140a1e989ba2ada089038ba865eeac10281bb7c76"
    sha256 monterey:       "4e5aeef147a8a57070ca71919eaa2d07a55bd140c549278a87613f9735870d85"
    sha256 x86_64_linux:   "a597c79ce61df47871de641099781406f41918f54aa7572f5ebd34ee8cffcd78"
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
