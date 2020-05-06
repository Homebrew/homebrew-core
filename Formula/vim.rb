class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://github.com/vim/vim/archive/v8.2.0700.tar.gz"
  sha256 "2c8756578b7b1e71a65ecf63f71af5d7eee2f94cd8cf4b3e10d9ee274e3fb37a"
  head "https://github.com/vim/vim.git"

  bottle do
    sha256 "6a7524e47eb80df02d815858562410a4b0f7ea691f34a3b2470d77995e062682" => :catalina
    sha256 "23ca312b2b69d2b0f89a7560aa88f4e2df5ecd8d913a19e5d7845e32807a1b2c" => :mojave
    sha256 "bd46bc3727bce808c5a6a66ad339440be3bf786e4ad06dfd3f360fa3663f39ba" => :high_sierra
  end

  depends_on "gettext"
  depends_on "lua"
  depends_on "perl"
  depends_on "python@3.8"
  depends_on "ruby"

  uses_from_macos "ncurses"

  conflicts_with "ex-vi",
    :because => "vim and ex-vi both install bin/ex and bin/view"

  conflicts_with "macvim",
    :because => "vim and macvim both install vi* binaries"

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"

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
                          "--enable-cscope",
                          "--enable-terminal",
                          "--with-compiledby=Homebrew",
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
