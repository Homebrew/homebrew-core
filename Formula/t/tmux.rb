class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.5a/tmux-3.5a.tar.gz"
  sha256 "16216bd0877170dfcc64157085ba9013610b12b082548c7c9542cc0103198951"
  license "ISC"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+[a-z]?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e371680cf27c72d30e70f57087bef3fadb408e1881a58839137625c10919f64"
    sha256 cellar: :any,                 arm64_sonoma:  "58e253aca23e3deb4b6e171419047cba7283a51cba51962351f5e51661d53437"
    sha256 cellar: :any,                 arm64_ventura: "7cfc60d84d3ec0ba61580633d7add6ffc0eeaa07ec27ceb2380fe434530c90bb"
    sha256 cellar: :any,                 sonoma:        "2e10a69a7d9828300ef1ec19f139c6d7eef7522d451e8812073460c4ba61ac28"
    sha256 cellar: :any,                 ventura:       "7d823e8b277d302563902e25b9e75594ad46f1996f9e53e5bb70d89c910bf092"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f1e10dbf08da58ff7e32cab75871cef72777a6d3f82e27a315ac0e292169db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8f77441d2c3db824f04268e62e1db8f240cbff682b12b40a77f5f3ae12f5a94"
  end

  head do
    url "https://github.com/tmux/tmux.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "ncurses"

  uses_from_macos "bison" => :build # for yacc

  # Old versions of macOS libc disagree with utf8proc character widths.
  # https://github.com/tmux/tmux/issues/2223
  on_system :linux, macos: :sierra_or_newer do
    depends_on "utf8proc"
  end

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/8da7f797245970659b259b85e5409f197b8afddd/completions/tmux"
    sha256 "4e2179053376f4194b342249d75c243c1573c82c185bfbea008be1739048e709"
  end

  def install
    system "sh", "autogen.sh" if build.head?

    args = %W[
      --enable-sixel
      --sysconfdir=#{etc}
    ]

    # tmux finds the `tmux-256color` terminfo provided by our ncurses
    # and uses that as the default `TERM`, but this causes issues for
    # tools that link with the very old ncurses provided by macOS.
    # https://github.com/Homebrew/homebrew-core/issues/102748
    args << "--with-TERM=screen-256color" if OS.mac? && MacOS.version < :sonoma
    args << "--enable-utf8proc" if OS.linux? || MacOS.version >= :high_sierra

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", *args, *std_configure_args

    system "make", "install"

    pkgshare.install "example_tmux.conf"
    bash_completion.install resource("completion")
  end

  def caveats
    <<~EOS
      Example configuration has been installed to:
        #{opt_pkgshare}
    EOS
  end

  test do
    system bin/"tmux", "-V"

    require "pty"

    socket = testpath/tap.user
    PTY.spawn bin/"tmux", "-S", socket, "-f", File::NULL
    sleep 10

    assert_path_exists socket
    assert_predicate socket, :socket?
    assert_equal "no server running on #{socket}", shell_output("#{bin}/tmux -S#{socket} list-sessions 2>&1", 1).chomp
  end
end
