class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.8/tmux-3.8.tar.gz"
  sha256 "e79c699c7e949dccd0a4a125e17b8d1261e311b16979dbc8eb34542f3966d82e"
  license "ISC"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+[a-z]?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c01ce1665582878b8d62f8768b220409195c9883d9c34820aa9cb58cbc27f37f"
    sha256 cellar: :any, arm64_tahoe:       "7af474204938c09cb35aef901d32e2633b90a27505eac076ac551170c3c393de"
    sha256 cellar: :any, arm64_sequoia:     "b436a1f261f94981c3b99429131bf719a8d56437896502815caac53a735db041"
    sha256 cellar: :any, arm64_linux:       "7c195f80f626a955f6d7843e543342b23bd9a3aad6d696734ef960d508437370"
    sha256 cellar: :any, x86_64_linux:      "464256bd8654358881e8a29043eac0f9c154b0eb5c82568761728f8f28c5e710"
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
