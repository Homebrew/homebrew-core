class VimMinimal < Formula
  desc "Minimalistic Vim formula with optional dependencies"
  homepage "https://vim.sourceforge.io/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://github.com/vim/vim/archive/v8.0.1400.tar.gz"
  sha256 "9e9cdfc137858f2d52276b6df826875aafc9d65b3e46d5d7f8c68deb40da3dbb"
  head "https://github.com/vim/vim.git"

  option "with-override-system-vi", "Override system vi"
  option "with-gettext", "Build vim with National Language Support (translated messages, keymaps)"
  option "with-client-server", "Enable client/server mode"

  LANGUAGES = %w[lua luajit perl python python3 ruby].freeze
  CUSTOM_MESSAGES = {
    "python3" => "Build vim with python3 instead of python[2] support",
  }.freeze

  LANGUAGES.each do |language, msg|
    option "with-#{language}", CUSTOM_MESSAGES[language] || "Build vim with #{language} support"
  end

  depends_on "lua" => :optional
  depends_on "luajit" => :optional
  depends_on "perl" => :optional
  depends_on "python" => :optional
  depends_on "python3" => :optional
  depends_on "ruby" => :optional
  depends_on "gettext" => :optional
  depends_on :x11 if build.with? "client-server"

  conflicts_with "ex-vi",
    :because => "vim and ex-vi both install bin/ex and bin/view"

  conflicts_with "vim",
    :because => "vim-minimal and vim install the same executables"

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")

    opts = []

    if build.with?("lua") || build.with?("luajit")
      ENV["LUA_PREFIX"] = HOMEBREW_PREFIX
      opts << "--enable-luainterp"
      opts << "--with-luajit" if build.with? "luajit"

      if build.with?("lua") && build.with?("luajit")
        onoe <<~EOS
          Vim will not link against both Luajit & Lua simultaneously.
          Proceeding with Lua.
        EOS
        opts -= %w[--with-luajit]
      end
    end

    if build.with?("python") || build.with?("python3")
      # python 2 takes precedence if both options have been set
      python = build.with?("python") ? "python" : "python3"
      opts << "--enable-#{python}interp"

      ENV.prepend_path "PATH", Formula[python].opt_libexec/"bin"

      # vim doesn't require any Python package, unset PYTHONPATH.
      ENV.delete("PYTHONPATH")
    end

    %w["perl ruby"].each do |language|
      opts << "--enable-#{language}interp" if build.with? language
    end

    opts << "--disable-nls" if build.without? "gettext"
    opts << "--enable-gui=no"

    if build.with? "client-server"
      opts << "--with-x"
    else
      opts << "--without-x"
    end

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
                          *opts
    system "make"
    # Parallel install could miss some symlinks
    # https://github.com/vim/vim/issues/1031
    ENV.deparallelize
    # If stripping the binaries is enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # https://github.com/vim/vim/issues/114
    system "make", "install", "prefix=#{prefix}", "STRIP=#{which "true"}"
    bin.install_symlink "vim" => "vi" if build.with? "override-system-vi"
  end

  test do
    if build.with? "python3"
      (testpath/"commands.vim").write <<~EOS
        :python3 import vim; vim.current.buffer[0] = 'hello python3'
        :wq
      EOS
      system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
      assert_equal "hello python3", File.read("test.txt").chomp
    elsif build.with? "python"
      (testpath/"commands.vim").write <<~EOS
        :python import vim; vim.current.buffer[0] = 'hello world'
        :wq
      EOS
      system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
      assert_equal "hello world", File.read("test.txt").chomp
    end
    if build.with? "gettext"
      assert_match "+gettext", shell_output("#{bin}/vim --version")
    end
  end
end
