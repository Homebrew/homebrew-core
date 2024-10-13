class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.5.10/tig-2.5.10.tar.gz"
  sha256 "f655cc1366fc10058a2bd505bb88ca78e653ff7526c1b81774c44b9d841210e3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "4862a62a7c7967879894e3b095e1182b646d71739d64d18153ab4a63128b72a3"
    sha256 cellar: :any,                 arm64_sonoma:   "372a23df16908a4ee4675c4dfdb9cd53f95968f6b62244e0e10bd84cb13ad660"
    sha256 cellar: :any,                 arm64_ventura:  "8fafbc01320019683b4bb381cd95543d788408bcd217286422ab54e3180d2ee8"
    sha256 cellar: :any,                 arm64_monterey: "7004415dce168189e7f459081d68baadfb8aa781733ae3a858307f0489ae939e"
    sha256 cellar: :any,                 sonoma:         "e175be4f0484d331b148f01e8868f637b1e71969cafe0007bb6525c9d1e87598"
    sha256 cellar: :any,                 ventura:        "13140511436346fbef6d45f20e5fffd4858f911601f1a50397fb9f34dbfb1599"
    sha256 cellar: :any,                 monterey:       "c1a13170d288f0c098e1d5b6703ebbc807dfe32f4d5228f5b6b1c69524aefa08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2922e2c8f02dd9b87674969802439d113b62f6bb6af4ff2acd185bb35f3198b"
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
