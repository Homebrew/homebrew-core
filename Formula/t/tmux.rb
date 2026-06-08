class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.6b/tmux-3.6b.tar.gz"
  sha256 "390759d25fdba016887ec982b808927e637070fd7d03a8021f8ef3102b9ae3c7"
  license "ISC"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+[a-z]?)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "eea20efb40cb19e2c3a55c0607ab171cf4cda5cbfaeb547b4fe13776d7b79f20"
    sha256 cellar: :any,                 arm64_sequoia: "199b6026e3d8216fb8fc6394ba047e96e177b8283bc832c8fd784a27951aa0b3"
    sha256 cellar: :any,                 arm64_sonoma:  "239749337e5b4b435670bf05fccc3373a001c0c018078ede8640b3e45203e316"
    sha256 cellar: :any,                 sonoma:        "367eb4c58e2c4aca023a7331a6649444c6c115658224988654ffecd19a23ce5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71a11a462753c538c074fb25784490bf49b9e65cdfedd091a62eea13b22e1665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "566c10149a1560226818f2cc6a82c3b7a626773d41cca1a96c4013314671a7f8"
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
