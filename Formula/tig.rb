class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.5.8/tig-2.5.8.tar.gz"
  sha256 "b70e0a42aed74a4a3990ccfe35262305917175e3164330c0889bd70580406391"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a433db97a4470854452df7310d11758fea48ffd75a4e1e8a9f3b3ddae789dc44"
    sha256 cellar: :any,                 arm64_monterey: "f6fde5e50a8665094751838fafa4ffab2548ffc46e6676b10ce39074429d2cb7"
    sha256 cellar: :any,                 arm64_big_sur:  "6fdce8500cbc679b4ef77d545135ffe93be67a55858966a3775c06ce1d6e35ec"
    sha256 cellar: :any,                 ventura:        "e1bd241e23b1dc78017372f04959356801e23a2750b51d84e564e4ed124185e9"
    sha256 cellar: :any,                 monterey:       "768e3c0d3d8c4842bce7de7d63e7bcf9d092c8872b7a67d2c737efaf0aa81d6f"
    sha256 cellar: :any,                 big_sur:        "1637bc2253879491360476a653b798a9736e585ee543e3ef0f54f571bdbee7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "962b5b01903e102b59a90b6a321b1d23d1bbda68b19d715f890a4b4a62c0421f"
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
