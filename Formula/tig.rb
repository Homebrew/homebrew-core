class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.5.2/tig-2.5.2.tar.gz"
  sha256 "1e5a8175627231ba619686ec338b4ad2843a6526122ea4e9fde1739dd2b4830b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7c1b4b40c1f893351de1bc4d8c5554eb4c5bae20cd7ac5655ca7bb88e9ae6794"
    sha256 cellar: :any_skip_relocation, big_sur:       "7182cb61a5f767710e6ad1d62abdd95454396e1dabcf77c6a1eb2fb87352b66a"
    sha256 cellar: :any_skip_relocation, catalina:      "0f63ed7e08ee5099695a7868057ce70903f411bedbf95939bd1161c24b42ccef"
    sha256 cellar: :any,                 mojave:        "64c2c022ceb003be21ca97d84a288cd5796c571972735331029af6dab110c57f"
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
