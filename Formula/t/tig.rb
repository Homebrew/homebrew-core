class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.5.11/tig-2.5.11.tar.gz"
  sha256 "b36ef52b1a19d87257adfa9047cc3e21d6bd528bbd28458fe49003eb3e374aa7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aa61c6a63da8bc0feb8dd2de4d21376d57a5f42b4e727b8ebdf74f5241d85111"
    sha256 cellar: :any,                 arm64_sonoma:  "b66928d9cc7ba87d4f24eece47a37d72662212283810b27124d0e0244a7f0173"
    sha256 cellar: :any,                 arm64_ventura: "e5989c7fc20f47bced9febb9124edbdd921312084572af22a611dd3efb814f85"
    sha256 cellar: :any,                 sonoma:        "9805c1bed21da365e97e99972a3a78a4d1d227ce79421322d4f22fcb2c691068"
    sha256 cellar: :any,                 ventura:       "8a774db5a2af8a65a4a6444f0ae86ed3fb251d84e097f37f9727185a60aa3df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "490695435c1d97a9f05d3b8d1f40e9ff2b30336d817e7451a71ad054fa4eb376"
  end

  head do
    url "https://github.com/jonas/tig.git", branch: "master"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xmlto" => :build
  end

  depends_on "pkgconf" => :build
  # https://github.com/jonas/tig/issues/1210
  depends_on "ncurses"
  depends_on "pcre2"
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
