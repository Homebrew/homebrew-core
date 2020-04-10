class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.5.1/tig-2.5.1.tar.gz"
  sha256 "500d5d34524f6b856edd5cae01f1404d14f3b51a9a53fd7357f4cebb3d4c9e64"

  bottle do
    cellar :any
    sha256 "03f5fc99e3763dc90dd4e2a3445fb9e4a65a2db790b8aa40c1d56cd08d1d5f6f" => :catalina
    sha256 "5fbd4ddf058724d51f88221bb54f949dd79941d7654f63881c62bf9768a7e12e" => :mojave
    sha256 "8c85a68d1ff0400649e18b47160152ea1220e72afa6217d916462ecc7053bf14" => :high_sierra
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

  def caveats
    <<~EOS
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
