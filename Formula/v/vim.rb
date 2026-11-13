class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated once a day
  url "https://github.com/vim/vim/archive/refs/tags/v9.2.1342.tar.gz"
  sha256 "321d6b7832b9c6def7fb7f533d28266a4a4f80e46506cedeea177e26096b2957"
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
    sha256 arm64_golden_gate: "3e5d46b1ef935edec235734f2a4ff1602bc2608055e603307db892fb9a29f3d9"
    sha256 arm64_tahoe:       "1616f2b2a3ca8f54c130895d299ee99e122900e9895c93fa54fa573c4208784d"
    sha256 arm64_sequoia:     "ae1ed811e03d4cee8f4d21a4d4930f151d31b97b40071dc396889bdfd871ecdb"
    sha256 arm64_linux:       "a9a3e266b733476cb9fb6742fbc5e684abaa7d74c2ca1cb5b1a7869339ec444d"
    sha256 x86_64_linux:      "c56a7556a1d2057ce293c8358b7424bc4c746d780f7d699d339c295c8672791d"
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

  def extra_deps = deps.select { |dep| dep.build? && dep.test? }

  deny_network_access!

  def install
    ENV.prepend_path "PATH", python3.dirname

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
    "Additional features can be enabled by installing: #{extra_deps.map(&:name).join(", ")}"
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
