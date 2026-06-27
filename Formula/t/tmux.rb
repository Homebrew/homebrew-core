class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.7/tmux-3.7.tar.gz"
  sha256 "2344f191501b8a73eb71dd6c5fd5dcf8c765f5066f34ab46f04b3013dc7bc1a5"
  license "ISC"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+[a-z]?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0097a7e2d5cdd24cc4830986512aa75b192a854ace573221ce15bd2c5501e0c2"
    sha256 cellar: :any, arm64_sequoia: "9c26a129b39471cdf1ff9b1885676628b3807367208edc4487b18a5ea0b8d05c"
    sha256 cellar: :any, arm64_sonoma:  "8be38ace419d9164494e13354c9633751943cda9ddee1799c689c50fc97fc667"
    sha256 cellar: :any, sonoma:        "ae9c5b1434b6cd56d36af51ec58b3e321fe500aef537c3ef0645ac9682842907"
    sha256 cellar: :any, arm64_linux:   "1a5f6fddefc0e53cb81bca3264064b4798712bc199e9db19d3543cf6694101b2"
    sha256 cellar: :any, x86_64_linux:  "970ec53ae032b99f0cba860bb143246405d032704d3a4821ea3f60aa77edd83b"
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
