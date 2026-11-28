class VimClassic < Formula
  desc "Vim 8 long term support version with no LLM-generated code"
  homepage "https://vim-classic.org/"
  url "https://git.sr.ht/~sircmpwn/vim-classic/archive/v8.3.1.tar.gz"
  sha256 "1d9baef8dab6751145b7c4460e85c0af1f4c432bf8ff03d8db13b977fca31e8c"
  license "Vim"

  bottle do
    manifest_sha256 "1f0a2706a838ef433f7832677ae42c16b034915366d6ec39749be527bd59d650"
    sha256 arm64_golden_gate: "8c4f557bd6f096c1d0bf29dfb0c898654227def6f2a9d5e330cc71319b3f70c5"
    sha256 arm64_tahoe:       "3121c85d28de68639b7c4788a359dda9c8a4e15aead23e16331e2d256ab5ae99"
    sha256 arm64_sequoia:     "2ec28ae6e1bfa81d91f54b1e3057cb7c129595cda8a45fa01421bb3205f177c9"
    sha256 arm64_linux:       "114aa74b27901649ebe6ce15612c4fe6d224c9e2ce85e8270bae456ba457673f"
    sha256 x86_64_linux:      "31a5f868ba90f7558198ef9f5c7c78a00920064dfa50cfa01617bdc8012dc0d5"
  end

  # Homebrew Ruby installs (4.x) currently cause a linker error with vim-classic,
  # so we don't try building in Ruby interpreter support.
  depends_on "gettext" => :build
  depends_on "lua" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]

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

  def extra_deps = deps.build.select(&:test?)

  def install
    ENV.prepend_path "PATH", python3.dirname

    # Allow dynamically loading formulae libraries when not linked
    extra_deps.each do |dep|
      extra_rpath = dep.opt_lib
      extra_rpath = rpath(target: extra_rpath) if OS.mac? # cannot use $ORIGIN
      ENV.append "LDFLAGS", "-Wl,-rpath,#{extra_rpath}"
    end

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    perl_linkage = "=dynamic" unless OS.mac?
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
           "--mandir=#{man}",
           "--enable-multibyte",
           "--with-tlib=ncurses",
           "--with-compiledby=Homebrew",
           "--enable-cscope",
           "--enable-terminal",
           "--enable-perlinterp#{perl_linkage}",
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
    dependency_names = extra_deps.map(&:name).join(", ")
    "Additional features can be enabled by installing: #{dependency_names}"
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
