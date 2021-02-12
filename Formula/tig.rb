class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.5.2/tig-2.5.2.tar.gz"
  sha256 "1e5a8175627231ba619686ec338b4ad2843a6526122ea4e9fde1739dd2b4830b"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8981a3341850eec12635de144174fab3198f73b530ed5979413334ddeabf0bf7"
    sha256 cellar: :any, big_sur:       "5a7ab3c18f11a0a2e0517648ab884ae245483f095c8397d67550cec98b661d37"
    sha256 cellar: :any, catalina:      "e3dd84d1883ca04013d72311c248f623a3e55fa8fa31456f5fe956ae19ccd4de"
    sha256 cellar: :any, mojave:        "0fbc0ae28aed58f73b1e798cbe75c8d131762c91371bd00e5a257c3a6fda7f85"
    sha256 cellar: :any, high_sierra:   "9f6983f67cbbe6d551c8ab39131ca1e91e9f3e57ffe1f1791e6c182fd017fbf8"
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
