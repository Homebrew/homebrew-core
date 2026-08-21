class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.6.1/tig-2.6.1.tar.gz"
  sha256 "5adeabdcd93aa0423d618da8b878b53482bef6e0e9e1fe224acc0f18031fe91e"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a83c57684c8ea6b7f227bbcde3385a7fcc8187104b3ad8e21391e2dd9699f84a"
    sha256 cellar: :any, arm64_sequoia: "0af8cce2768d41d225e143bc885894897a9976194c69c0246e89e99e5b972462"
    sha256 cellar: :any, arm64_sonoma:  "bde1eea41c2bdbb2d40ad021c36c2ecf821206a7da64975cfa46a947e26c2b6a"
    sha256 cellar: :any, sonoma:        "e01745b354d91ca068ac1cde11405337567381d10a7398b2e86fb1e742fc039c"
    sha256 cellar: :any, arm64_linux:   "252d7ae196715d4cbe1e7f9f1a8089d253e4b3388f2bbfdfaec0c7cad62efbae"
    sha256 cellar: :any, x86_64_linux:  "4c3c8760b5f00cac02fc809e82c7fcc99ade4b53c5ba7d3a3af465af7aa70e3b"
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
