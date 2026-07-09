class VimClassic < Formula
  desc "Vim 8 long term support version with no LLM-generated code"
  homepage "https://vim-classic.org/"
  url "https://git.sr.ht/~sircmpwn/vim-classic/archive/v8.3.0.tar.gz"
  sha256 "6e1c97c8269e9354bbc474f0efa7e1e0b23fcdb6075067474d731a9bfac6e8ef"
  license "Vim"

  bottle do
    sha256               arm64_tahoe:   "7bce18cd76b55002dddd04c9eb9ac47fdfc1a9c92147854455165959bb15ab53"
    sha256               arm64_sequoia: "bd0739551806f358d2dfdebb5a168fd2f9759c8219c72bc305e323b4147e2225"
    sha256               arm64_sonoma:  "b67e80a92a1c36f06c3d05f3f004b46b9883d2239ead12c1f877e5ce7d347c8d"
    sha256 cellar: :any, sonoma:        "ef1d55aac7aa8a441e56f1fc58f9a7aa18153c59f792cd862c38b979066e69bb"
    sha256               arm64_linux:   "e5f40a11cd33362be0cbe6eac7fa377b9a509b351c085a596548c25adccb7e50"
    sha256               x86_64_linux:  "8842d6b9aaf6401bdaac782ffff54b17a56819998d4b3559b9249878ac9c07f2"
  end

  # Homebrew Ruby installs (4.x) currently cause a linker error with vim-classic,
  # so we don't try building in Ruby interpreter support.
  depends_on "gettext" => :build
  depends_on "lua" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]

  uses_from_macos "perl" => [:build, :test]
  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
  end

  conflicts_with "ex-vi", because: "vim and ex-vi both install bin/ex and bin/view"
  conflicts_with "macvim", because: "vim and macvim both install vi* binaries"
  conflicts_with "vim", because: "vim and vim-classic both install vi* binaries"

  def extra_deps = deps.select { |dep| dep.build? && dep.test? }

  def install
    ENV.prepend_path "PATH", formula_opt_libexec("python@3.14")/"bin"

    # Allow dynamically loading formulae libraries when not linked
    extra_deps.each do |dep|
      extra_rpath = dep.to_formula.opt_lib
      extra_rpath = rpath(target: extra_rpath) if OS.mac? # cannot use $ORIGIN
      ENV.append "LDFLAGS", "-Wl,-rpath,#{extra_rpath}"
    end

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
           "--mandir=#{man}",
           "--enable-multibyte",
           "--with-tlib=ncurses",
           "--with-compiledby=Homebrew",
           "--enable-cscope",
           "--enable-terminal",
           "--enable-perlinterp#{"=dynamic" unless OS.mac?}",
           "--enable-python3interp=dynamic",
           # Homebrew Ruby installs (4.x) currently cause a linker error with vim-classic,
           # so don't try building in Ruby interpreter support.
           # "--enable-rubyinterp=dynamic",
           "--disable-gui",
           "--without-x",
           "--enable-luainterp=dynamic",
           "--with-lua-prefix=#{formula_opt_prefix("lua")}"
    system "make"
    # Parallel install could miss some symlinks
    # https://github.com/vim/vim/issues/1031
    ENV.deparallelize
    system "make", "install", "prefix=#{prefix}"
    bin.install_symlink "vim" => "vi"
  end

  def caveats
    "Additional features can be enabled by installing: #{extra_deps.map(&:name).join(", ")}"
  end

  test do
    (testpath/"commands.vim").write <<~VIM
      :perl $curbuf->Append(0, "hello perl")
      :lua vim.buffer():insert("hello lua")
      :wq
    VIM
    system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello perl\n\nhello lua", File.read("test.txt").chomp
    assert_match "+gettext", shell_output("#{bin}/vim --version")
  end
end
