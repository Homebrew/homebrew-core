class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz"
  sha256 "e4fd347843bd0772c4f48d6dde625b0b109b7a380ff15db21e97c11a4dcdf93f"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+[a-z]?)["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "6c72c3fbce35b39cb8e4df69cb18c288cd01744f5394c912a8f72539a6700a32"
    sha256 cellar: :any,                 arm64_monterey: "0ca53c250a3e70d97ca511edd13f2d16660e4e94a41465a8708306e03b231b76"
    sha256 cellar: :any,                 arm64_big_sur:  "89a9edfec5e665df5b9e2e0f47e1721c1e074725846705819042a9c691683981"
    sha256 cellar: :any,                 ventura:        "8edbb91fb9e3d7411a8ade0b8417251c17dcf4de295050dcfc5e4e62a144ae71"
    sha256 cellar: :any,                 monterey:       "c0489c25fa963b14fd5d3c53eb50f681e85bb7a5716883afe77c1efbdea7c882"
    sha256 cellar: :any,                 big_sur:        "85eb7ec949aad04ad0a550a4a8151bc4453e229d813fda0be724f17fd8cf40e1"
    sha256 cellar: :any,                 catalina:       "3cb3c779b9e62f0f5f5d9204309d194148ee66e3bc930480cabf7bee1b897623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2eed5059099ba7ffeb68260c3163184b5d9b6a09e3b9b80d33ab2bf007513d8"
  end

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    uses_from_macos "bison" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "ncurses"

  # Old versions of macOS libc disagree with utf8proc character widths.
  # https://github.com/tmux/tmux/issues/2223
  on_high_sierra :or_newer do
    depends_on "utf8proc"
  end

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/f5d53239f7658f8e8fbaf02535cc369009c436d6/completions/tmux"
    sha256 "b5f7bbd78f9790026bbff16fc6e3fe4070d067f58f943e156bd1a8c3c99f6a6f"
  end

  def install
    system "sh", "autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    # tmux finds the `tmux-256color` terminfo provided by our ncurses
    # and uses that as the default `TERM`, but this causes issues for
    # tools that link with the very old ncurses provided by macOS.
    # https://github.com/Homebrew/homebrew-core/issues/102748
    args << "--with-TERM=screen-256color" if OS.mac?
    args << "--enable-utf8proc" if MacOS.version >= :high_sierra

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", *args

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
