class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.3.2/tig-2.3.2.tar.gz"
  sha256 "6410e51c6149d76eac3510d04f9a736139f85e7c881646937d009caacf98cff1"
  revision 1

  bottle do
    sha256 "31bc0f57539393ca38dfe8e60c5a67bd2844e36f934c9c15aaa635cb413c23ee" => :high_sierra
    sha256 "65fb2c2852ca01cf5f8b1f344e4486fa78edc203d987fdc78b6222f6b8606101" => :sierra
    sha256 "edc285535427f0255e184e360bc2efb87f7d86cab4e70f796a58bb62c349c708" => :el_capitan
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
