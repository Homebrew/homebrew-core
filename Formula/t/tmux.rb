class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.7c/tmux-3.7c.tar.gz"
  sha256 "7c60cae9a0e25288e2e24750aafc9e8800fc7fd4555e447e1b29ee4201cfb3bf"
  license "ISC"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+[a-z]?)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "d4e277920c4ad6838d167244d7f38aacb45f089b8e4486742c7c35f34842e89b"
    sha256 cellar: :any, arm64_tahoe:       "9d4125a2d773a037da826d46599fa8fdde23381ca72e896af582b6a63d8f031f"
    sha256 cellar: :any, arm64_sequoia:     "b912a00996bb0421af49913cdd8019a1cb07140cb83af66f70df73c3ec58bb7f"
    sha256 cellar: :any, arm64_sonoma:      "3ce8e889304a25593f701500e063c7e75b79bb90a1a8cedfe51052da2032cf48"
    sha256 cellar: :any, arm64_linux:       "b25b98ebd2006119ab17f42bb9333f640f2b3362eb05bbe0096fbadd018ae55a"
    sha256 cellar: :any, x86_64_linux:      "861cca7012fab1ccf773e254837d476cc48d519f908f460bd3d2988530c993d2"
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
  depends_on "utf8proc"

  uses_from_macos "bison" => :build # for yacc

  on_macos do
    # https://github.com/tmux/tmux/blob/62044f02dff22d304da78ac81b69afcf84872ac7/CHANGES#L169-L170
    # https://github.com/tmux/tmux/issues/5385
    depends_on "jemalloc"
  end

  # runs a server as a test
  allow_network_access! :test

  def install
    system "sh", "autogen.sh" if build.head?

    args = %W[
      --enable-sixel
      --sysconfdir=#{etc}
      --enable-utf8proc
    ]

    # tmux finds the `tmux-256color` terminfo provided by our ncurses
    # and uses that as the default `TERM`, but this causes issues for
    # tools that link with the very old ncurses provided by macOS.
    # https://github.com/Homebrew/homebrew-core/issues/102748
    args << "--with-TERM=screen-256color" if OS.mac? && MacOS.version < :sonoma

    system "./configure", *args, *std_configure_args
    system "make", "install"

    pkgshare.install "example_tmux.conf"
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
