class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.4.1/tig-2.4.1.tar.gz"
  sha256 "b6b6aa183e571224d0e1fab3ec482542c1a97fa7a85b26352dc31dbafe8558b8"
  revision 1

  bottle do
    sha256 "ee892fc9cf84e4d71b0353f0be2ec4b30be58d843975111d605cb4cb1dfc1f2f" => :mojave
    sha256 "7212ea8dafd00af09770b01c3fd4e8e0f8fd0dbec15182443713e2e28a429bbb" => :high_sierra
    sha256 "f5bb2f81aede65620461805770e47cf27f78450416918322079fcb4b5ef92a97" => :sierra
    sha256 "328074d19609efd84dce823240a23142962091c49ca10ea3fd01c1143a49e207" => :el_capitan
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
