class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.4.1/tig-2.4.1.tar.gz"
  sha256 "b6b6aa183e571224d0e1fab3ec482542c1a97fa7a85b26352dc31dbafe8558b8"
  revision 1

  bottle do
    cellar :any
    sha256 "eba3a55c27fa0574f50afa7c93992e2ca977bfec4614c3cbf659a8139af33ef9" => :mojave
    sha256 "4a73419c6034c18896d658938992a2c3ec8f4c5cd0567323cde27c6270861d03" => :high_sierra
    sha256 "09939bc22023b396db534f278257343b0752509a53eea5f2a417cbb0a47b3b8c" => :sierra
  end

  head do
    url "https://github.com/jonas/tig.git"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xmlto" => :build
  end

  depends_on "readline"

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
