class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "ebb1f10006fe49f964a356494f96d86a4f06eb018659e3b9bde63b25c03abdf0"
  license "BSD-4-Clause"
  revision 2
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "585f98cda2324655c14dcd9d64acc8d07e1fd72aaf2680a6f770f59a4246f281"
    sha256 arm64_sonoma:  "279bd5d4f6667722e3375d8538f84b54a131b2cb477477e95ac6b3d360df7ebb"
    sha256 arm64_ventura: "81d1a05ef52307578a974ef1c729b03524b97ae9125d386918c737a48f8bd0a6"
    sha256 sonoma:        "43dffed01d4f245375aad615bfc05593b62f2f54fe5b32b81e5181f1c9736b80"
    sha256 ventura:       "5ceaed8adb32424c8484f4b8a24c87e90a269f3f3a3f1177934a88bfe7e4712c"
    sha256 arm64_linux:   "4457a50b8a4ced2c0a2c66c4806c2f6bba4394ccc180fcab326e5dd8f042cce5"
    sha256 x86_64_linux:  "c3927fa72b5ba98e83d749bfe3a31fab8bb45ca6c929019249e317638323a6a0"
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
