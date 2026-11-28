class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated once a day
  url "https://github.com/vim/vim/archive/refs/tags/v9.2.1419.tar.gz"
  sha256 "9616263caea51f81de0318d0dc522375595030bc6744824dcc2d1290dd59cd0b"
  license "Vim"
  compatibility_version 1
  head "https://github.com/vim/vim.git", branch: "master"

  # The Vim repository contains thousands of tags and the `Git` strategy isn't
  # ideal in this context. This is an exceptional situation, so this checks the
  # first 10 tags using the GitHub tags feed (to minimize data transfer).
  livecheck do
    url "https://github.com/vim/vim/tags.atom"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :xml do |xml, regex|
      xml.get_elements("//title").map { |item| item.text[regex, 1] }
    end
    throttle days: 1
  end

  bottle do
    manifest_sha256 "74859eec91375aa4adad0c6816e70acb3c6e8599dbd0c4cf48c5a366eba92c9c"
    sha256 arm64_golden_gate: "fa5fce21a7e40fc901f256a76397ee69abbf8fa1106f7e6f7d41e2ca33ca78da"
    sha256 arm64_tahoe:       "148a65dd797b531a2902e1fd55ee675aa37e90cd7bb75c6aea217a3d0546de54"
    sha256 arm64_sequoia:     "c409d087a566653b8327e7cc11fff59acddec5d7eeb0632843f207f4599027ff"
    sha256 arm64_linux:       "dbbce1cd017dced9c914197ddcee6cd3e3f152bc33208db664b378c271975791"
    sha256 x86_64_linux:      "6dae4b2af16779f077f55fa9af516c2f6a5b7c297e4551b813bb3330a48e0d47"
  end

  depends_on "gettext" => :build
  depends_on "lua" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]
  depends_on "ruby" => [:build, :test]
  depends_on "libsodium"
  depends_on "ncurses"

  uses_from_macos "perl" => [:build, :test]

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
  end

  conflicts_with "ex-vi", because: "vim and ex-vi both install bin/ex and bin/view"
  conflicts_with "macvim", because: "vim and macvim both install vi* binaries"
  conflicts_with "vim-classic", because: "vim and vim-classic both install vi* binaries"

  def extra_deps = deps.build.select(&:test?)

  deny_network_access!

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
                          "--enable-rubyinterp=dynamic",
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
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :ruby Vim::Buffer.current.append(0, 'hello ruby')
      :perl $curbuf->Append(0, "hello perl")
      :lua vim.buffer():insert("hello lua")
      :wq
    VIM
    system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello perl\nhello ruby\nhello python3\nhello lua", File.read("test.txt").chomp
    assert_match "+gettext", shell_output("#{bin}/vim --version")
    assert_match "+sodium", shell_output("#{bin}/vim --version")
  end
end
