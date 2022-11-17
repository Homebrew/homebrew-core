class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.5.7/tig-2.5.7.tar.gz"
  sha256 "dbc7bac86b29098adaa005a76161e200f0734dda36de9f6bd35a861c7c29ca76"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e5714a87f936aa18a67e0194f1620322cd414a5cbe7a60c162fe019ca1089441"
    sha256 cellar: :any,                 arm64_monterey: "223dec6016b112b2657201767e02956e25fed98e31e4fdfaed25388cb75c4b94"
    sha256 cellar: :any,                 arm64_big_sur:  "fef3c697604de0bd9c63d6a7a215477f2b607b38446e12d8b89fd0e29491476f"
    sha256 cellar: :any,                 ventura:        "54fbb690bb8007fd3923a0893059a8c4059b7b47aec9491ecd2e2632e3798bc3"
    sha256 cellar: :any,                 monterey:       "0e589cfbd49883f2c7c36b33fddfff2c87ae1b834d29291d07b8d01fbeda5a2d"
    sha256 cellar: :any,                 big_sur:        "67d6a03327396458bf3c5c0ce55448d26be124ea90bfe7203da46d5eaf7f49a9"
    sha256 cellar: :any,                 catalina:       "38fc1871df548ed93dcd7318f51e18818c4d0c341f89ddc5bb888b5241375d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c06537c36fe31445917ed77f8c97778bc59b88cc8ac00f140bb990a9b71a303f"
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
