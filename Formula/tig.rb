class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.5.6/tig-2.5.6.tar.gz"
  sha256 "50bb5f33369b50b77748115c730c52b13e79b2de49cba7167bb634eb683d965f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e4bd07be2479e864e8fea79167f589b4a814fd6763884dc655669376967d951f"
    sha256 cellar: :any,                 arm64_big_sur:  "e41c34b9e4623ca62d939e262227f08eae94e65f5d9b07c5d954e47b26821e87"
    sha256 cellar: :any,                 monterey:       "576b76f771205ed4035f91ee72480444d1747bd3a50e0a5a84dfaa1e0000168e"
    sha256 cellar: :any,                 big_sur:        "6c736d456b1976ff68e4260e7a53e1899946983eff895cf2e2aac1211367dad8"
    sha256 cellar: :any,                 catalina:       "1a1d6d8c69a404403f66ede87c116bc258002b5505343ad79e34642349185503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90626519f92ed599160dab696f2317e2a2f047acd0914c0ee04e9cb0d22231c8"
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
