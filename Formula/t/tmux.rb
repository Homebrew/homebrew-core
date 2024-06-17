class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz"
  sha256 "551ab8dea0bf505c0ad6b7bb35ef567cdde0ccb84357df142c254f35a23e19aa"
  license "ISC"
  revision 1

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+[a-z]?)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "defd2c5057e1f44cd545dd8c8a79246d860a71d9be88ccbc5e8128ef2ec6f94f"
    sha256 cellar: :any,                 arm64_ventura:  "32be1a9082ff54dc7f98f92fb91f72e00f31b9b24e3bc97434ad1a769763c057"
    sha256 cellar: :any,                 arm64_monterey: "8903753c2b5466cb6d28524b5f9582041e0955a0a2280e6e7d269b6068cd84d2"
    sha256 cellar: :any,                 sonoma:         "963013100e07ffe267686b21f362ad916c37070959b4d8184ac68ed1fdf1693a"
    sha256 cellar: :any,                 ventura:        "59ce7af5006e873f2f1afb464ac9876ec111b28067495510e76c0e6a08760607"
    sha256 cellar: :any,                 monterey:       "c6ec914966f86259aae1d8f77cc50174589013ae03733c27d644ff115269d5ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d029ba70c4e7eae66ab6928a71415bc52c4462801e3f1d8834d915b2bfffbe08"
  end

  head do
    url "https://github.com/tmux/tmux.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "ncurses"

  uses_from_macos "bison" => :build # for yacc

  # Old versions of macOS libc disagree with utf8proc character widths.
  # https://github.com/tmux/tmux/issues/2223
  on_system :linux, macos: :sierra_or_newer do
    depends_on "utf8proc"
  end

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/f5d53239f7658f8e8fbaf02535cc369009c436d6/completions/tmux"
    sha256 "b5f7bbd78f9790026bbff16fc6e3fe4070d067f58f943e156bd1a8c3c99f6a6f"
  end

  def install
    system "sh", "autogen.sh" if build.head?

    args = %W[
      --enable-sixel
      --sysconfdir=#{etc}
    ]

    if OS.mac?
      # tmux finds the `tmux-256color` terminfo provided by our ncurses
      # and uses that as the default `TERM`, but this causes issues for
      # tools that link with the very old ncurses provided by macOS.
      # https://github.com/Homebrew/homebrew-core/issues/102748
      args << "--with-TERM=screen-256color" if MacOS.version < :sonoma
      args << "--enable-utf8proc" if MacOS.version >= :high_sierra
    else
      args << "--enable-utf8proc"
    end

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
    PTY.spawn bin/"tmux", "-S", socket, "-f", "/dev/null"
    sleep 10

    assert_predicate socket, :exist?
    assert_predicate socket, :socket?
    assert_equal "no server running on #{socket}", shell_output("#{bin}/tmux -S#{socket} list-sessions 2>&1", 1).chomp
  end
end
