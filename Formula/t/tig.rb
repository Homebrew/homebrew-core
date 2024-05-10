class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.5.9/tig-2.5.9.tar.gz"
  sha256 "0cb4d9e3de00dc92aaa7996e1517845bd9b9a0d4368f3206f618d813e8db8b39"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eb710508b4937b3af5be0014a91fbb1a05ba7da6388dcc2af17150deb6814c9b"
    sha256 cellar: :any,                 arm64_ventura:  "aa0ec3fe86d13d31572c09e7331d072679cfc0e52c531bf7734e6eefe62644a9"
    sha256 cellar: :any,                 arm64_monterey: "5b2c5a6fef39e71285c7dedc47c5ab0a60cad37a1f7e5f80efb740dfaffcc9da"
    sha256 cellar: :any,                 sonoma:         "ee62286ad4688cbf402e28d48f7e8c137d87e5db934da8becc0afe6a2750e298"
    sha256 cellar: :any,                 ventura:        "215caf8b17fc9834c61b8d3f6ba9fb13558cd9863972da48fa5b7961efd28571"
    sha256 cellar: :any,                 monterey:       "a83118a41754e188baa0041125cecb71dfb71a9b493a226a7dd65d7533c9a639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "328850e5f06c75881e4c4a1fac4e0261c81568ae91700c03a1b82e1931020922"
  end

  head do
    url "https://github.com/jonas/tig.git", branch: "master"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xmlto" => :build
  end

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
