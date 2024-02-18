class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz"
  sha256 "551ab8dea0bf505c0ad6b7bb35ef567cdde0ccb84357df142c254f35a23e19aa"
  license "ISC"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+[a-z]?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a08171578c7d4d7b119762def24287f8a3f9b233c0967e837e0d98e7ad25d9c3"
    sha256 cellar: :any,                 arm64_ventura:  "a1c3e1f58e9ad9a5f1f811c8b71a78acbbcdf96ffb6b04141ed0b343b6ca8844"
    sha256 cellar: :any,                 arm64_monterey: "9e3a38bbdf781413bfbb092ca0c54ee5b4d5602cbdfe76194ecaedd30f9747f4"
    sha256 cellar: :any,                 sonoma:         "4f25fb0148c79d3710a7c1366ad05de469f6a2695ef3b3c0ea64a8ffe7228f9e"
    sha256 cellar: :any,                 ventura:        "258a4e1d8c6398f126abfd9e01725be4518233280c6f93b9b77bba75963426ca"
    sha256 cellar: :any,                 monterey:       "277f1642992f9cf1923bf47fbefdd50ea39bf2bb0f7171b9429d84fe77a7a296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3842883605afca7b6470f042f6c81a6e5c27cc5dff6b95806cad91ee30dbe32e"
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
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    if OS.mac?
      # tmux finds the `tmux-256color` terminfo provided by our ncurses
      # and uses that as the default `TERM`, but this causes issues for
      # tools that link with the very old ncurses provided by macOS.
      # https://github.com/Homebrew/homebrew-core/issues/102748
      args << "--with-TERM=screen-256color"
      args << "--enable-utf8proc" if MacOS.version >= :high_sierra
    else
      args << "--enable-utf8proc"
    end

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
