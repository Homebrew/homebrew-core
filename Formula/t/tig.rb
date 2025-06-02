class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.5.12/tig-2.5.12.tar.gz"
  sha256 "5dda8a098810bb499096e17fc9f69c0a5915a23f46be27209fc8195d7a792108"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec253fa15a03de0700d9c0f9a14c3ae7b08f571699b3825998206ccabd71064d"
    sha256 cellar: :any,                 arm64_sonoma:  "edb0ab2037d0f64854b02b1a833112a5270a5dbe141b4e75308c738b6e27d020"
    sha256 cellar: :any,                 arm64_ventura: "6b982e872791e8a01725f6e1db1c488d9c77e321a0b6769568c503284bb4df1b"
    sha256 cellar: :any,                 sonoma:        "f01d03e19a861f8bd0f0d98cfefed23d5c981ee985c7493c7db8c5d1cf2665b4"
    sha256 cellar: :any,                 ventura:       "b0a904409d4bd3b97ec6462c54764284783d2ddf93b66ada941b997215c7abd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6323819fb231932abc3ffddd85db0338395690e5b024c3a671af0996fd93671b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a4b4183690c0a092452acce166b01db0e86c0fda649dae1b87ca8f5a2de206f"
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
