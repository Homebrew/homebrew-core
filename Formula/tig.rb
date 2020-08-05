class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.5.1/tig-2.5.1.tar.gz"
  sha256 "500d5d34524f6b856edd5cae01f1404d14f3b51a9a53fd7357f4cebb3d4c9e64"

  bottle do
    cellar :any
    sha256 "e3dd84d1883ca04013d72311c248f623a3e55fa8fa31456f5fe956ae19ccd4de" => :catalina
    sha256 "0fbc0ae28aed58f73b1e798cbe75c8d131762c91371bd00e5a257c3a6fda7f85" => :mojave
    sha256 "9f6983f67cbbe6d551c8ab39131ca1e91e9f3e57ffe1f1791e6c182fd017fbf8" => :high_sierra
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
