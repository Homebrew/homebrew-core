class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://github.com/vim/vim/archive/v8.2.3550.tar.gz"
  sha256 "c27b57349f36d5b5c4058f25f812ea50e71bc8e32f4568fdf8b9dbb10160c4bf"
  license "Vim"
  head "https://github.com/vim/vim.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "8921cb90638bd7c362b0a4da0f3c07595df376d21494aa17efc998addf769c94"
    sha256 arm64_big_sur:  "8eb7cbc28633eb7f093a161962a8f508229fb084c4d62489ca71b282754a897a"
    sha256 monterey:       "31732bcf4347200013d24ceb4cafc0785847df77fd85563b09b646ae8c59a5cb"
    sha256 big_sur:        "b025e3a0f4c15339e9c8125c5a9487d5e1f9813a8b665a1629156a8e19268ce5"
    sha256 catalina:       "5dc0a0d4f70c10f3d5e6371c688d6b89e9d2aa1ed440f780d6d61030d87dd97d"
    sha256 mojave:         "76d2a15cb4d8ef2411f176cc6ba788e62aba368f81b70568219528b8ff7cea00"
    sha256 x86_64_linux:   "3d2a2377d4c6ffe0fe96b27405496308c87a74fd3e9ca2c4a06a74b3ba90f7c0"
  end

  depends_on "gettext"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.9"
  depends_on "ruby"

  conflicts_with "ex-vi",
    because: "vim and ex-vi both install bin/ex and bin/view"

  conflicts_with "macvim",
    because: "vim and macvim both install vi* binaries"

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

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
                          "--enable-gui=no",
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
