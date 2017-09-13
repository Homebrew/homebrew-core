class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "http://jonas.nitro.dk/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.2.2/tig-2.2.2.tar.gz"
  sha256 "316214d87f7693abc0cbe8ebbb85decdf5e1b49d7ad760ac801af3dd73385e35"

  bottle do
    sha256 "91ebc14f09bce40903be7619cdafe3d7fbffb787dd2bc2c9fe806e3c71389d30" => :sierra
    sha256 "0b72d1eb75e02e5f88e034caeb1517f2330fc3d2c4b61bee78cc408703d5167b" => :el_capitan
    sha256 "0c0fc044284bcf4d73d5fa2c479421101b5ae7a59e07055d843572ef2a3ae8ce" => :yosemite
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

  test do
    assert_match version.to_s, shell_output("#{bin}/tig -v")
  end
end
