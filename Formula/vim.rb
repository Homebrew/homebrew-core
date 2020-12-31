class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://github.com/vim/vim/archive/v8.2.2250.tar.gz"
  sha256 "be1de89b4e41d17a4f27bb70210e9e7d334b80a8f488659617d0742e0cd1bbbd"
  license "Vim"
  revision 1
  head "https://github.com/vim/vim.git"

  bottle do
    sha256 "322b126a67ba779a89999b4df91a17ac94e4967e0dad9922866f2f8db8a44256" => :big_sur
    sha256 "a8b7584db1d8a3e77ef9b5a2a7f58754911f847ebd4e688ea387ab0be4234b19" => :arm64_big_sur
    sha256 "6a46c763b64b947a91f16dcffa842616ab54d1eef920fffd9a0fbf9218adf340" => :catalina
    sha256 "643f2072aec4943b4a49bb94354264bc6800b9db313b16b1ac86ed06bf252ba4" => :mojave
  end

  depends_on "gettext"
  depends_on "lua"
  depends_on "perl"
  depends_on "python@3.9"
  depends_on "ruby"

  uses_from_macos "ncurses"

  conflicts_with "ex-vi",
    because: "vim and ex-vi both install bin/ex and bin/view"

  conflicts_with "macvim",
    because: "vim and macvim both install vi* binaries"

  # Fix vimscript issue that was fixed upstream in 8.2.2251 (just missed our cutoff of every 50 releases)
  # Remove the next time vim is updated.
  patch do
    url "https://github.com/vim/vim/commit/a04d447d3aaddb5b978dd9a0e0186007fde8e09e.patch?full_index=1"
    sha256 "ddc00f61dc75e3875ea490c56b9cf843f20292844bc34ad434c566ab30e2335a"
  end

  def install
    # Fix error: '__declspec' attributes are not enabled
    ENV.append_to_cflags "-fdeclspec"

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
