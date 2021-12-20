class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://github.com/vim/vim/archive/v8.2.3850.tar.gz"
  sha256 "c4a05b3e691b0a666f9983d179cd2e24248e92017344f5e16adf100d133a5d96"
  license "Vim"
  head "https://github.com/vim/vim.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "d9e4d4065ef0a4f458000c6aeafaf4625279a8da4a97229e457cc24208f9649c"
    sha256 arm64_big_sur:  "391a607bfd78d4c9d8e174c42cdf5fa8fef168618f8e8c361afe9675b91a009e"
    sha256 monterey:       "3e03cca209d9dd8de8f4e218cf0fe606617e40d862840d629ffd36a7a434b0d4"
    sha256 big_sur:        "68dd1feb9a54dda0f325c56f9ee30f10e0211f3f3e731b22df2d08023278f651"
    sha256 catalina:       "fcac711b10bfe559420a280f040cecbd835453d303d45e82ff37c4370df86b46"
    sha256 x86_64_linux:   "8a8007b665f686ca2def6751bad0388c4f0c13e670fe78a2ff4463a9e0089e8f"
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
