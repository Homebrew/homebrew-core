class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.4.1/tig-2.4.1.tar.gz"
  sha256 "b6b6aa183e571224d0e1fab3ec482542c1a97fa7a85b26352dc31dbafe8558b8"

  bottle do
    sha256 "cc10f4c5f2565695ea7242bd5785eac825fb93edd8674e9104f4be42ac9424a2" => :high_sierra
    sha256 "3c7030954f808cc780b3161081bf4479532835f8e603b0605609c8b18e9b77a3" => :sierra
    sha256 "209c931ce11600b591be4ffdb981b55ac7644c356e2b48ea271e228ad98f56fe" => :el_capitan
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
