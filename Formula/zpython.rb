class Zpython < Formula
  desc "Embeds a Python interpreter into zsh"
  homepage "https://bitbucket.org/ZyX_I/zsh"
  head "https://bitbucket.org/ZyX_I/zsh.git", :branch => "zpython"

  stable do
    url "https://downloads.sourceforge.net/project/zsh/zsh/5.0.5/zsh-5.0.5.tar.bz2"
    mirror "https://www.zsh.org/pub/old/zsh-5.0.5.tar.bz2"

    # We prepend `00-` for the first version of the zpython module, which is
    # itself a patch on top of zsh and does not have own version number yet.
    # Hoping that upstream will provide tags that we could download properly.
    # Starting here with `00-`, so that once we get tags for the upstream
    # repository at https://bitbucket.org/ZyX_I/zsh.git, brew outdated will
    # be able to tell us to upgrade zpython.
    version "00-5.0.5"
    sha256 "6624d2fb6c8fa4e044d2b009f86ed1617fe8583c83acfceba7ec82826cfa8eaf"

    # Note, non-head version is completly implemented in this lengthy patch
    # later on, we hope to use https://bitbucket.org/ZyX_I/zsh.git to download a tagged release.
    patch do
      url "https://gist.githubusercontent.com/felixbuenemann/5790777/raw/cb5ea3b34617174e50fd3972792ec0944959de3c/zpython.patch"
      sha256 "73d6565536abe269cc7715e5200ba63000b7fb830c8975db7e5e6db2222e8f09"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0c575603cf568eaef05ef7de2a0f5f143a08728c97baebf508fc132926028146" => :high_sierra
    sha256 "6fd2ca965e862af6ebf0b24e158d34bbe66bafc522854adc96efa70e2a0fdb9b" => :sierra
    sha256 "aa8efa349bbf477746aee3cb977d1b0c430ec05d1947f2bd33667f054d8692cc" => :el_capitan
    sha256 "3f469a0820ec250a6875c97fd50626462b94a6d81ea93888d32391ababcf25bf" => :yosemite
    sha256 "9137eefb79a7a529b016e3c949e24a15d4747e4f35108f91db6ea58441f456a9" => :mavericks
  end

  depends_on "zsh"
  depends_on "autoconf" => :build

  def install
    args = %w[
      --disable-gdbm
      --enable-zpython
      --with-tcsetpgrp
    ]

    system "autoreconf"
    system "./configure", *args

    # Disable building docs due to exotic yodl dependency
    inreplace "Makefile", "subdir in Src Doc;", "subdir in Src;"

    system "make"
    (lib/"zpython/zsh").install "Src/Modules/zpython.so"
  end

  def caveats; <<~EOS
    To use the zpython module in zsh you need to
    add the following line to your .zshrc:

      module_path=($module_path #{HOMEBREW_PREFIX}/lib/zpython)

    If you want to use this with powerline, make sure you set
    it early in .zshrc, before your prompt gets initialized.

    After reloading your shell you can test with:
      zmodload zsh/zpython && zpython 'print "hello world"'
    EOS
  end

  test do
    system "zsh -c 'MODULE_PATH=#{HOMEBREW_PREFIX}/lib/zpython zmodload zsh/zpython && zpython print'"
  end
end
