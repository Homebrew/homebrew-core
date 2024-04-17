class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://github.com/vim/vim/archive/refs/tags/v9.1.0300.tar.gz"
  sha256 "d687bddb6145adf8fd3630c74a974ee1875254a41e14ef9192d4e6b9a3de73e2"
  license "Vim"
  head "https://github.com/vim/vim.git", branch: "master"

  # The Vim repository contains thousands of tags and the `Git` strategy isn't
  # ideal in this context. This is an exceptional situation, so this checks the
  # first 50 tags using the GitHub API (to minimize data transfer).
  livecheck do
    url "https://api.github.com/repos/vim/vim/tags?per_page=50"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :json do |json, regex|
      json.map do |tag|
        match = tag["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
    throttle 50
  end

  bottle do
    sha256 arm64_sonoma:   "2759d1db1f94cdbf99cff374458f16dd62b4087f71d73545d650744e5fa0b306"
    sha256 arm64_ventura:  "b4f978485d9caeb0dd2a529ca1ad177b45c7feecd318502c5de080feb4fc8d9e"
    sha256 arm64_monterey: "c04af1bc3e5b2df048913bcb81c9896d16284226c96cad2fbb382f07d12a6396"
    sha256 sonoma:         "985d913efe4e2e296c8bd38233c8c8e18343ab75157ce161555354a464e9c178"
    sha256 ventura:        "d10245db14f0f9e49084b140dcdec5916de913bd830632c088d8c1871133969c"
    sha256 monterey:       "a980122b5d7eacde6af2b5257cb46ce0c5b978174092a41f0132cbf4c660d391"
    sha256 x86_64_linux:   "1176edbc5be4ffb70c6154dfbaf798891d0d215b619f2b69e89ed9ec3ce38f46"
  end

  depends_on "gettext"
  depends_on "libsodium"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.12"
  depends_on "ruby"

  on_linux do
    depends_on "acl"
  end

  conflicts_with "ex-vi",
    because: "vim and ex-vi both install bin/ex and bin/view"

  conflicts_with "macvim",
    because: "vim and macvim both install vi* binaries"

  def install
    ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec/"bin"

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
                          "--disable-gui",
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
    assert_match "+sodium", shell_output("#{bin}/vim --version")
  end
end
