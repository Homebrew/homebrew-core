class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.7b/tmux-3.7b.tar.gz"
  sha256 "87f2e99e3b685973f2ca002ffd6ed7e51a5744f7009daae5a15670b6d532db96"
  license "ISC"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+[a-z]?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7fb61b4783521c34eabb64521de582bfe7c4c302a31a8d7fc8a130ae453d520e"
    sha256 cellar: :any, arm64_sequoia: "6fb9422c77c1cdc6fa518249322880c0880e2da1237ed1e3660341f19cc3efa2"
    sha256 cellar: :any, arm64_sonoma:  "8907e0911a938bdd25b14ab26fc3cb1f1993a44729cc9dcfa7fbcf51e042e44e"
    sha256 cellar: :any, sonoma:        "5ee0baf64e0ff4c2dc503abb87c4bca807a59a9da9ab3fcd54e65dbc06335c25"
    sha256 cellar: :any, arm64_linux:   "84ae807fef2aae78341be98498cc92aaf6cac13b38d683384a02be3d37eb3549"
    sha256 cellar: :any, x86_64_linux:  "0158cfce6a3c153853ceb325317e72defaec3970030ec05fe83a77edaf8b99d3"
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
