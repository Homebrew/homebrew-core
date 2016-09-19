class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "http://jonas.nitro.dk/tig/"
  url "http://jonas.nitro.dk/tig/releases/tig-2.2.tar.gz"
  sha256 "8f5213d3abb45ca9a79810b8d2a2a12d941112bc4682bcfa91f34db74942754c"
  revision 1

  bottle do
    cellar :any
    sha256 "7993e1b035d361ec63997c890bb5a3b28c73e23b773439fae25c44b71f9bda5a" => :sierra
    sha256 "99982b27386faa66282f3aca77570d5499d896efcc1001da3e5e6e3481d4334d" => :el_capitan
    sha256 "7d3a5c1f20a69259c5e559431a2da506d02d1cc71a164d5289d7c0abcb6e0ff0" => :yosemite
    sha256 "b2781db63aa8184f5bec9e8c385de224888fbdf91cc8847462a38a1ecbdf5bcd" => :mavericks
  end

  head do
    url "https://github.com/jonas/tig.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-docs", "Build man pages using asciidoc and xmlto"

  if build.with? "docs"
    depends_on "asciidoc"
    depends_on "xmlto"
  end

  depends_on "readline" => :recommended

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    # Ensure the configured `sysconfdir` is used during runtime by
    # installing in a separate step.
    system "make", "install", "sysconfdir=#{pkgshare}/examples"
    system "make", "install-doc-man" if build.with? "docs"
    bash_completion.install "contrib/tig-completion.bash"
    zsh_completion.install "contrib/tig-completion.zsh" => "_tig"
    cp "#{bash_completion}/tig-completion.bash", zsh_completion
  end

  def caveats; <<-EOS.undent
    A sample of the default configuration has been installed to:
      #{opt_pkgshare}/examples/tigrc
    to override the system-wide default configuration, copy the sample to:
      #{etc}/tigrc
    EOS
  end
end
