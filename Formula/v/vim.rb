class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://github.com/vim/vim/archive/refs/tags/v9.2.0200.tar.gz"
  sha256 "8456b6e7688e742df5df0498f80081a0ec323c0c213d4565dd5d41aff4cd5c9d"
  license "Vim"
  compatibility_version 1
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
    sha256 arm64_tahoe:   "e1f448bb0f1d3315648d525edfb0078de7c04076a3f763f0bb1ceb51076506d4"
    sha256 arm64_sequoia: "bb5eb97a86719dd222584a57dd3fb80d6bee92727e4e110067553bdaa7d7449d"
    sha256 arm64_sonoma:  "f5d2d03ea5b3fcf0254ed20bb0b816b5bb88584036ff2a3cc89b4fce64675eed"
    sha256 sonoma:        "850671d7d54d985ca2bfaa5be8bed5ee5e4acc4d94d940956f34bb5859903cd1"
    sha256 arm64_linux:   "61b6a483ccac2face468eddf2b0b452319f1bde1ecc73829cd26fa781838cde2"
    sha256 x86_64_linux:  "bcea480abe83669a34aa9864ab7c7afc259c7bd43e188ea2d439af260a7d571a"
  end

  depends_on "gettext" => :build
  depends_on "libsodium"
  depends_on "lua@5.4" # Lua 5.5 doesn't work for now, see https://github.com/vim/vim/issues/19639
  depends_on "ncurses"
  depends_on "python@3.14"
  depends_on "ruby"

  uses_from_macos "perl"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
  end

  conflicts_with "ex-vi", because: "vim and ex-vi both install bin/ex and bin/view"
  conflicts_with "macvim", because: "vim and macvim both install vi* binaries"

  def install
    ENV.prepend_path "PATH", Formula["python@3.14"].opt_libexec/"bin"

    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete("PYTHONPATH")

    ENV.append_to_cflags "-mllvm -enable-constraint-elimination=0" if DevelopmentTools.clang_build_version == 1600

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
                          "--with-lua-prefix=#{Formula["lua@5.4"].opt_prefix}"
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
    (testpath/"commands.vim").write <<~VIM
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    VIM
    system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", File.read("test.txt").chomp
    assert_match "+gettext", shell_output("#{bin}/vim --version")
    assert_match "+sodium", shell_output("#{bin}/vim --version")
  end
end
