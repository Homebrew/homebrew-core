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
    sha256 cellar: :any, arm64_tahoe:   "7752f62ec95bf0e4ce2ff72b5d3a93ea0416f74011bfbd9a162e6313a9f21212"
    sha256 cellar: :any, arm64_sequoia: "79e68da943f4c22dce73525b0f43498e67e1a58003cd8fa7280e7fa9ef7a4389"
    sha256 cellar: :any, arm64_sonoma:  "aa65f94dccdcaeb83b9795527fcba569e74939dd032609c888418cd3d39e08dd"
    sha256 cellar: :any, sonoma:        "73d79ea663a78fb72cfa7eafb7a692b6b00e29e2d6cabf1d1c23f880254e709b"
    sha256 cellar: :any, arm64_linux:   "d8539cc91c249cf306b1a3accccf79b7566887475d4dd193d98c7807c512b422"
    sha256 cellar: :any, x86_64_linux:  "f1549155ee257ad755f551c227b0160437efc77d7d89e63e723515df2d30b555"
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
