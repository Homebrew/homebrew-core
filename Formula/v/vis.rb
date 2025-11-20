class Vis < Formula
  desc "Vim-like text editor"
  homepage "https://github.com/martanne/vis"
  url "https://github.com/martanne/vis/archive/refs/tags/v0.9.tar.gz"
  sha256 "bd37ffba5535e665c1e883c25ba5f4e3307569b6d392c60f3c7d5dedd2efcfca"
  license "ISC"
  head "https://github.com/martanne/vis.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "9d3f2a7bde3bb933488eb286842e9eecfe7a65443189c12a3b1e351a3d2738e4"
    sha256 arm64_sequoia: "f1c209db49526dc713fdf8663255d7aef96ce0faf1cca2b2d037fa88888f975b"
    sha256 arm64_sonoma:  "4de1ac73095911d0aaebca111f7dd326b96c6eec57f5488e76be4ca56ab345e0"
    sha256 sonoma:        "30727e3f7d1ef664832a4f26127fefc72378b27ea57099b9a10c299494c2e6c3"
    sha256 arm64_linux:   "ca1b523f0ad09b716cee018694c0cea5a2fd54d2b5357e473fb4b94502eafa8e"
    sha256 x86_64_linux:  "8c183d876deb3dc5fbcd043e61bb3292eadeb90650e08fbe820d0e40eeebc3bd"
  end

  depends_on "pkgconf" => :build
  depends_on "libtermkey"
  depends_on "lpeg"
  depends_on "lua"
  depends_on "tre"

  uses_from_macos "unzip" => :build
  uses_from_macos "ncurses"

  def install
    system "./configure", "--enable-lua", "--enable-lpeg-static=no", *std_configure_args
    system "make", "install"

    return unless OS.mac?

    # Rename vis & the matching manpage to avoid clashing with the system.
    mv bin/"vis", bin/"vise"
    mv man1/"vis.1", man1/"vise.1"
  end

  def caveats
    on_macos do
      <<~EOS
        To avoid a name conflict with the macOS system utility /usr/bin/vis,
        this text editor must be invoked by calling `vise` ("vis-editor").
      EOS
    end
  end

  test do
    binary = if OS.mac?
      bin/"vise"
    else
      bin/"vis"
    end

    assert_match "vis #{version} +curses +lua", shell_output("#{binary} -v 2>&1")
  end
end
