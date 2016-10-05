class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "http://jonas.nitro.dk/tig/"
  url "http://jonas.nitro.dk/tig/releases/tig-2.2.tar.gz"
  sha256 "8f5213d3abb45ca9a79810b8d2a2a12d941112bc4682bcfa91f34db74942754c"
  revision 1

  bottle do
    cellar :any
    sha256 "f359f1fc63abc08d9e9cf21814a8bdf41c0c0d75257be28cb36f5920a4a4f54b" => :sierra
    sha256 "777f473b9b0bbd8554c0bf138d52511d33ec1d28c0c041098a4a8f52fc816b41" => :el_capitan
    sha256 "e126cee0ef1cec3d6bd933f596c64ace6e0dadb0633d154e8bd921237bb93170" => :yosemite
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
