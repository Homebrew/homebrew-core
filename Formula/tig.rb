class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.5.7/tig-2.5.7.tar.gz"
  sha256 "dbc7bac86b29098adaa005a76161e200f0734dda36de9f6bd35a861c7c29ca76"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d7e689e71aea7b13a21ace7239826dcfd6d493da0a945ae5777c75ff9cb4762c"
    sha256 cellar: :any,                 arm64_big_sur:  "c3bd9e02255bd84861548ba3146c2c70672b9c62e2ee99b377316c490b0ccb97"
    sha256 cellar: :any,                 monterey:       "267d3f3382c9c529ca89ebfa9cbe1f9dd0d06d95d7d3a0136c1c7b8a4386e7d2"
    sha256 cellar: :any,                 big_sur:        "c8f03d86100767a3f7c9e0e8cc473ec5ca5fcd814793e68b6709eb052c19109d"
    sha256 cellar: :any,                 catalina:       "c66beb5ce2ac91a2bd72eee2b2540fec169ee25436b33986848de55e783c5d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5aaec12532e09bbc9017e2eae5cc60c9a0c78fee6be44ab296db8e9eef116ca"
  end

  head do
    url "https://github.com/jonas/tig.git"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xmlto" => :build
  end

  # https://github.com/jonas/tig/issues/1210
  depends_on "ncurses"
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
