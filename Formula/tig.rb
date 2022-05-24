class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.5.5/tig-2.5.5.tar.gz"
  sha256 "24ba2c8beae889e6002ea7ced0e29851dee57c27fde8480fb9c64d5eb8765313"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a7d0bf9c1f535420cd5855c037280d5f7e3f7061c8a8f5c3178e567d92e8839c"
    sha256 cellar: :any,                 arm64_big_sur:  "3038dff468e2e130f161455b51a7a387bc76d1d3f700d7ddf549b2f391accc36"
    sha256 cellar: :any,                 monterey:       "69a497a92721ff1947ae97cfdacd7003b3991689c6ca81ee2bcf7378384fc9b0"
    sha256 cellar: :any,                 big_sur:        "b0d7cb650c15d1d07c1210cb27610c971c9216399547af10dcdd16c8bbd74eb6"
    sha256 cellar: :any,                 catalina:       "74ab1d678111673ba10abce9c05c3d77aa1f9ef66d5a51842d05f13594fb1a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09b38c3c63caf15b9cf3d3611692402ca02dbdcbac45e06ff3812810398fd38d"
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
