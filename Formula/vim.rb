class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://github.com/vim/vim/archive/v9.0.1150.tar.gz"
  sha256 "aaa03eaeb68e8ee39137c5ffb8d41b4cce58f53860724829aba6385454b98c69"
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
    sha256 arm64_ventura:  "83cbd74fcf0eba078b2120f7bb53bdd13381931476e0d2fea71a94b3343dcebd"
    sha256 arm64_monterey: "958259c81e90ed9694aa55f77fcb10a14183af67138156f187dfa6600dd355d7"
    sha256 arm64_big_sur:  "5839811608c29e3268667a2bcad623468e2d7689c8985a0679536d7b028810d4"
    sha256 ventura:        "d785642851beca95e1b9b5db008d8b5237a2bd742e806985a76b12cecfaa8374"
    sha256 monterey:       "b30ceceb1855af6ee2afde99ece159d800543fd9480d84ce696c70a421014d6c"
    sha256 big_sur:        "9bcf1154a1ced2067c542b6aae921dea3242d02486bda48842300875cb12b3f8"
    sha256 x86_64_linux:   "7c1dd5fc016aabfd343a0306c7398878f8edecfe8314726cd0d4328c2c826cfd"
  end

  depends_on "gettext"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.11"
  depends_on "ruby"

  conflicts_with "ex-vi",
    because: "vim and ex-vi both install bin/ex and bin/view"

  conflicts_with "macvim",
    because: "vim and macvim both install vi* binaries"

  # fixes build issue with 9.0.1150, remove after next release
  patch do
    url "https://github.com/vim/vim/commit/5bcd29b84e4dd6435177f37a544ecbf8df02412c.patch?full_index=1"
    sha256 "6d1ae23897088cc13b31ac22f268e74fa063364b7c9a892dbee32397d4d62faf"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"

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
