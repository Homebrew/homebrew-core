class VimAT74 < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "http://www.vim.org/"
  url "https://github.com/vim/vim/archive/v7.4.2367.tar.gz"
  sha256 "a9ae4031ccd73cc60e771e8bf9b3c8b7f10f63a67efce7f61cd694cd8d7cda5c"
  revision 6

  bottle do
    sha256 "0b7b258b8f27817c480d8f1504a264b04ed828f6d370601db39bcf05154d53a0" => :high_sierra
    sha256 "cd6e36f85919d76a547f1b269546a2e37c5ef5d3aab462a55834e0ab3abcf282" => :sierra
    sha256 "14227e1c8700a89c9925f15101a27f79a9cdeb4717471af5bf9d5026290eb219" => :el_capitan
  end

  keg_only :versioned_formula

  option "with-override-system-vi", "Override system vi"
  option "without-nls", "Build vim without National Language Support (translated messages, keymaps)"
  option "with-client-server", "Enable client/server mode"

  LANGUAGES_OPTIONAL = %w[lua mzscheme python3 tcl].freeze
  LANGUAGES_DEFAULT  = %w[perl python ruby].freeze

  if MacOS.version >= :mavericks
    option "with-custom-python", "Build with a custom Python 2 instead of the Homebrew version."
    option "with-custom-ruby", "Build with a custom Ruby instead of the Homebrew version."
    option "with-custom-perl", "Build with a custom Perl instead of the Homebrew version."
  end

  option "with-python3", "Build vim with python3 instead of python[2] support"
  LANGUAGES_OPTIONAL.each do |language|
    option "with-#{language}", "Build vim with #{language} support"
  end
  LANGUAGES_DEFAULT.each do |language|
    option "without-#{language}", "Build vim without #{language} support"
  end

  depends_on :python => :recommended
  depends_on "python3" => :optional
  depends_on :ruby => "1.8" # Can be compiled against 1.8.x or >= 1.9.3-p385.
  depends_on :perl => "5.3"
  depends_on "lua" => :optional
  depends_on "luajit" => :optional
  depends_on :x11 if build.with? "client-server"

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")
    ENV["LUA_PREFIX"] = HOMEBREW_PREFIX if build.with?("lua") || build.with?("luajit")

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete("PYTHONPATH")

    if build.with?("python") && which("python").to_s == "/usr/bin/python" && !MacOS::CLT.installed?
      # break -syslibpath jail
      ln_s "/System/Library/Frameworks", buildpath
      ENV.append "LDFLAGS", "-F#{buildpath}/Frameworks"
    end

    opts = []

    (LANGUAGES_OPTIONAL + LANGUAGES_DEFAULT).each do |language|
      opts << "--enable-#{language}interp" if build.with? language
    end

    if opts.include?("--enable-pythoninterp") && opts.include?("--enable-python3interp")
      # only compile with either python or python3 support, but not both
      # (if vim74 is compiled with +python3/dyn, the Python[3] library lookup segfaults
      # in other words, a command like ":py3 import sys" leads to a SEGV)
      opts -= %w[--enable-pythoninterp]
    end

    opts << "--disable-nls" if build.without? "nls"
    opts << "--enable-gui=no"

    if build.with? "client-server"
      opts << "--with-x"
    else
      opts << "--without-x"
    end

    if build.with? "luajit"
      opts << "--with-luajit"
      opts << "--enable-luainterp"
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
    # Simple test to check if Vim was linked to Python version in $PATH
    if build.with? "python"
      vim_path = bin/"vim"

      # Get linked framework using otool
      otool_output = `otool -L #{vim_path} | grep -m 1 Python`.gsub(/\(.*\)/, "").strip.chomp

      # Expand the link and get the python exec path
      vim_framework_path = Pathname.new(otool_output).realpath.dirname.to_s.chomp
      python_framework_path = `python2-config --exec-prefix`.chomp

      assert_equal python_framework_path, vim_framework_path
    end
  end
end
