class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.5.4/tig-2.5.4.tar.gz"
  sha256 "c48284d30287a6365f8a4750eb0b122e78689a1aef8ce1d2961b6843ac246aa7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "75fec92f280daf4789ccd06a2ad809185032cbd98097baffeb6b0b283b9212ef"
    sha256 cellar: :any,                 arm64_big_sur:  "ca3273a9bb53f6b060ce4ccbffaf82308d90d833a7120505a55f877b6f197592"
    sha256 cellar: :any,                 monterey:       "3ff950a8d1588789c3b4bb86f998464f3b69ebbf37aca1403a43b8499f93f244"
    sha256 cellar: :any,                 big_sur:        "506b2d47105b97ba9d04f3b91a45e9a164dd409fc1fd58655bf3015bb1403e0b"
    sha256 cellar: :any,                 catalina:       "5afa0c1a9dcb4d851f88db05b0f911e70014abb6d64b43d1b1e56f12452d233a"
    sha256 cellar: :any,                 mojave:         "c2dff759957d7b62f5ab947e6637c428c9352c244faeb6f8e02918f8c9587771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a71079791b2ff79c307250f00163c3320ba6c242f4115892fa490d78a71196f9"
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
