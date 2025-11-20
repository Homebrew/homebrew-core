class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.6.0/tig-2.6.0.tar.gz"
  sha256 "99d4a0fdd3d93547ebacfe511195cb92e4f75b91644c06293c067f401addeb3e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5464963cbef880b886995cebc53ba6465f96a360a08ab04a0652b98a691d7de2"
    sha256 cellar: :any,                 arm64_sequoia: "8e4dfb08982c3aa19fab2a11c5f9d0c9ba4bc84f31be5b6eb1949f550330b947"
    sha256 cellar: :any,                 arm64_sonoma:  "6aef8066f91d46c4ce81efdad40d741f89ea45fa6b3e9f324f7a4f2aebe430e3"
    sha256 cellar: :any,                 sonoma:        "0a3dd5d81806bac10f99984b1e84d5d89c857a706207ddee9ca82ea00c0eb15f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4281d358afb993ded992ad26db2c21c1f08c1389b88bb2732e26e204c001439b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfe9453ea284cf1c2a94073e7da2f52b0d1f645a620b3401d4a39b3ba4bd697a"
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
