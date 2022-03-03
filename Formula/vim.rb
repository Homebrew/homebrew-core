class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://github.com/vim/vim/archive/v8.2.4500.tar.gz"
  sha256 "9fd0341a5c93c439a06f0eb9b036f9ac5b1eb6495ee54491d7367a5c17be5841"
  license "Vim"
  head "https://github.com/vim/vim.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "c199caaf0e78761d253e302e5e3f9ada277ba9e86d23643150a616d5d6a61531"
    sha256 arm64_big_sur:  "ce8708db48088edffdc0bb7a42dc21fa646e52526ece410420a06c763de448ef"
    sha256 monterey:       "7c1f0faff756addf04a45f05b300f49020a718a8fb42650f3f9d25f363816f8b"
    sha256 big_sur:        "22b72d4448ea730111145579e4c2e238e10b1fc3259980dd9dd004735700c52f"
    sha256 catalina:       "b131b4a0494220de668e3cbc7fc2d5ea3f9a095346d19c8f82fcec6b958a9dc8"
    sha256 x86_64_linux:   "17ed0aad4f85334fc3bac0792449bf8dacb9e8c6b808713602477f0c694eb57e"
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
