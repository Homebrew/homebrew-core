class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.3.2/tig-2.3.2.tar.gz"
  sha256 "6410e51c6149d76eac3510d04f9a736139f85e7c881646937d009caacf98cff1"
  revision 1

  bottle do
    sha256 "25dbafb1b42cdcec87fb4ab3d0d65cb1eb4a34d524cf382adc4b52808a537440" => :high_sierra
    sha256 "a1105dd17e379c72e8e8e0e82cda206dd718b6fa14bcbfef9038567b8475e553" => :sierra
    sha256 "2f169188f3e4f6dd2478fdc530809461831314029f121ee324d264a29ae2eae6" => :el_capitan
  end

  head do
    url "https://github.com/jonas/tig.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "readline" => :recommended

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

  def caveats; <<~EOS
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
