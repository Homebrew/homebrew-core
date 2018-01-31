class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.3.3/tig-2.3.3.tar.gz"
  sha256 "d39d10c5a6db7b7663d51eff8ac2eaf075e319f5edabe09cb63a2b1b24846bea"

  bottle do
    sha256 "9bbd56c8a58a4e531c6270935bd8e8709e5d7d772734bf261f98ce08f16a9f37" => :high_sierra
    sha256 "df8ceddb1c0995bb979cdfe5aebda733109c2de10de7a6c8457642a0b03cb556" => :sierra
    sha256 "32bf134ee42ac9f7ae5307110bffbd811579ef85917087a9755567574d23692a" => :el_capitan
  end

  head do
    url "https://github.com/jonas/tig.git"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xmlto" => :build
  end

  depends_on "readline" => :recommended

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    # Ensure the configured `sysconfdir` is used during runtime by
    # installing in a separate step.
    system "make", "install", "sysconfdir=#{pkgshare}/examples"
    system "make", "install-doc-man"
    bash_completion.install "contrib/tig-completion.bash"
    zsh_completion.install "contrib/tig-completion.zsh" => "_tig"
    cp "#{bash_completion}/tig-completion.bash", zsh_completion
  end

  def caveats; <<~EOS
    A sample of the default configuration has been installed to:
      #{opt_pkgshare}/examples/tigrc
    to override the system-wide default configuration, copy the sample to:
      #{etc}/tigrc
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tig -v")
  end
end
