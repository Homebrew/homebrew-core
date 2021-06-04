class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.5.3/tig-2.5.3.tar.gz"
  sha256 "e528068499d558beb99a0a8bca30f59171e71f046d76ee5d945d35027d3925dc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e8c3f31998bc34f660d1749114aca139284588cde9f3e4c550fbb31125369e3b"
    sha256 cellar: :any, big_sur:       "f22519146f5e4513fddc73702f00914bd9cae7afcb51004a75f8485ab373423a"
    sha256 cellar: :any, catalina:      "e5b4e30109382f230b167339c00b7697c51b1a21a85cd070a94d5c3f462844fc"
    sha256 cellar: :any, mojave:        "d54fd173ad117ad5a6c89df4bc8f388822150818f2e1ec0e406d25e4e67abc19"
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
