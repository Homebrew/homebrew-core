class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated once a day
  url "https://github.com/vim/vim/archive/refs/tags/v9.2.1332.tar.gz"
  sha256 "3cd253ad44a42be755579174e4554e20bc7863abf82fb2de5a6914f3e8a2f617"
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
    sha256 arm64_golden_gate: "9f94426030da6ca4a378ebf1abe474f1a80bd5eca87b8ae03ef9423efc1b18f3"
    sha256 arm64_tahoe:       "1067e190896451a59a68830ad55c67ee2ba142c48376b5caf26a8f568cc19f3f"
    sha256 arm64_sequoia:     "52db7d1a6eb354a2a52694ea871e38a1e3783778718bdf201e14ae5e46342e6f"
    sha256 arm64_linux:       "2c640bc1b46f0b2378c095d6120799bb130924bac2e57c47b7620f7d51548168"
    sha256 x86_64_linux:      "a55c2996bd4f1a8d1499a7e2416f796129d18bad1b48b66914a3001a76626dd1"
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
