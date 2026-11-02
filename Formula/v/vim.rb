class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated once a day
  url "https://github.com/vim/vim/archive/refs/tags/v9.2.1276.tar.gz"
  sha256 "86526fd2cc08ef853442341d1f134b94fc765807a96b29f50ad906aac8b8d98c"
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
    sha256 arm64_golden_gate: "2a95a6c36d54e3e1068dd39314252e39a2ffef2782de25fcb7e1b52fcb5e5547"
    sha256 arm64_tahoe:       "072c9f8e1fcbded561f401ee15b4300dcbc2f5070c23e83ee4927163151c87f5"
    sha256 arm64_sequoia:     "01c48a611d41806d2fc1b8f81c01889520b3270afe6b1395e95326984657e2ed"
    sha256 arm64_linux:       "d827bfd7c28abe43801a5945944e7485183861932d647054034175924506a71e"
    sha256 x86_64_linux:      "ed9ba53d19b6f22f4a430be9fc8d03d8b448f476ca343fe8beee34606a8c7906"
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
