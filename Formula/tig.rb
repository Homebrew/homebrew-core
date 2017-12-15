class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.3.1/tig-2.3.1.tar.gz"
  sha256 "4ba555a23475946aa1c51b7f4d70beeb4a5a535cdf9d1f06978d24e2003e9201"

  bottle do
    sha256 "7ee4d3602940b21b8d9a9af504e37519bca1378f2a4a959ba553f4334a4b9a27" => :high_sierra
    sha256 "47f74e5b1b4da196651ae4852cc9d7f4496bec53752da8428fb9eb78efbfb0fc" => :sierra
    sha256 "da55d31b23fe60a4da0658f785a001f73fcb553bbd6677920eca10c477e94539" => :el_capitan
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
