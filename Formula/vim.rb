class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://github.com/vim/vim/archive/v9.0.1000.tar.gz"
  sha256 "f35922c1135d6232b30726abce741d462272fad25f985d06cd812963015cf0f7"
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
    sha256 arm64_ventura:  "a6f1010634b35c5806f27f273da82c8bc88c88067f4f1d86de17617a1d8bb89b"
    sha256 arm64_monterey: "24675828ad9f92c7f22803bb7cb3378fb5019e8ac8f83f58da08702cc79bb32f"
    sha256 arm64_big_sur:  "d1cc4580fcecce9fad6358090b7425751b53a93676a42bd92c9f40d0d645f311"
    sha256 ventura:        "13ff1941e768a75865fcf4602f625ed8f37bc1b9dd814e4e52bd69a47a4114b0"
    sha256 monterey:       "f0b8b52b5868117ed3e9d87e2182013fe4af86f7b129290ea943ca00df6e3328"
    sha256 big_sur:        "0638bfae13b9c0b2ab7e7426c44833fa61635064a5b9473eeb858c3a4bb574c3"
    sha256 catalina:       "a3d7367f1ea4f36973dbdcc04dcf8f66ff30718ad88a4da71f4eccd56163d0eb"
    sha256 x86_64_linux:   "7b7bc85ff2dfa14f3f95f9d87a9fa0e07a1ab9cd3b4edd039ff1f559970020d2"
  end

  depends_on "gettext"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.10"
  depends_on "ruby"

  conflicts_with "ex-vi",
    because: "vim and ex-vi both install bin/ex and bin/view"

  conflicts_with "macvim",
    because: "vim and macvim both install vi* binaries"

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"

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
  end
end
