class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://github.com/vim/vim/archive/refs/tags/v9.1.0150.tar.gz"
  sha256 "a650d21f627cbb50ea6cb08e566cfc2fd565635583513d78c000cf7dcb667ec0"
  license "Vim"
  head "https://github.com/vim/vim.git", branch: "master"

  # The Vim repository contains thousands of tags and the `Git` strategy isn't
  # ideal in this context. This is an exceptional situation, so this checks the
  # first page of tags on GitHub (to minimize data transfer).
  livecheck do
    url "https://github.com/vim/vim/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_sonoma:   "28fb07081aeaefa1864747ed178a513e828be1fb675f05bb17e5d6d906e2c780"
    sha256 arm64_ventura:  "623813f161c1b71dce847ac9d6ace8dd828ae01e7eb485e58601447e170bcdd2"
    sha256 arm64_monterey: "719be799ad7c9311a6e46ed612d4bc84b8a32ae374e3588ddc505b65a22708a5"
    sha256 sonoma:         "1e445120cc5de83923593ebddedbdec362f4e2847c2a86a50e1f088af0686346"
    sha256 ventura:        "3b7c700ce9c544bdbf0f0b94d3d55e50c0ec265d27d6c5cd8025732a947b00dd"
    sha256 monterey:       "c3d114a5f900e40993fce185b1185e37e8643c80764a36dd0becef97683d030c"
    sha256 x86_64_linux:   "1567bc1a19316eb93136b5cfa74ae7da5594703449046ee3d52120609e8e1a8b"
  end

  depends_on "gettext"
  depends_on "libsodium"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.12"
  depends_on "ruby"

  on_linux do
    depends_on "acl"
  end

  conflicts_with "ex-vi",
    because: "vim and ex-vi both install bin/ex and bin/view"

  conflicts_with "macvim",
    because: "vim and macvim both install vi* binaries"

  def install
    ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec/"bin"

    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete("PYTHONPATH")

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    # Homebrew will use the first suitable Perl & Ruby in your PATH if you
    # build from source. Please don't attempt to hardcode either.
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--with-compiledby=Homebrew",
                          "--enable-cscope",
                          "--enable-terminal",
                          "--enable-perlinterp",
                          "--enable-rubyinterp",
                          "--enable-python3interp",
                          "--disable-gui",
                          "--without-x",
                          "--enable-luainterp",
                          "--with-lua-prefix=#{Formula["lua"].opt_prefix}"
    system "make"
    # Parallel install could miss some symlinks
    # https://github.com/vim/vim/issues/1031
    ENV.deparallelize
    # If stripping the binaries is enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # https://github.com/vim/vim/issues/114
    system "make", "install", "prefix=#{prefix}", "STRIP=#{which "true"}"
    bin.install_symlink "vim" => "vi"
  end

  test do
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", File.read("test.txt").chomp
    assert_match "+gettext", shell_output("#{bin}/vim --version")
    assert_match "+sodium", shell_output("#{bin}/vim --version")
  end
end
