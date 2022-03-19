class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  license "ISC"
  revision 1

  stable do
    url "https://github.com/tmux/tmux/releases/download/3.2a/tmux-3.2a.tar.gz"
    sha256 "551553a4f82beaa8dadc9256800bcc284d7c000081e47aa6ecbb6ff36eacd05f"

    # Fix occasional crash on exit.
    # Remove with the next release (3.3).
    patch do
      url "https://github.com/tmux/tmux/commit/5fdea440cede1690db9a242a091df72f16e53d24.patch?full_index=1"
      sha256 "3752098eb9ec21f4711b12d399eaa1a7dcebe9c66afc147790fba217edcf340f"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+[a-z]?)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "34ea39085a19233bc1f87bcc360cb3bdd52dd5842399bb7e0ad16bcb1f815234"
    sha256 cellar: :any,                 arm64_big_sur:  "3138a67aceee5eea374c6a61e799073f661ce132f8b8ff2ee2b5cef06fb93725"
    sha256 cellar: :any,                 monterey:       "7355c39cf84eebe6ac33cf15959ca7867eb50c86791f1e5a053193750810c5fe"
    sha256 cellar: :any,                 big_sur:        "db717e09b9e53769b9bc6f277d25f20c8ec159eb90093a45c0ceefb54105509a"
    sha256 cellar: :any,                 catalina:       "9aa7eba75f4f56f099182ecd7d41cad0117ce1a11f9fcbd8319a22015c317898"
    sha256 cellar: :any,                 mojave:         "fa64cb30acc5300390f65f29ed95b4a816f1431b3dbd94051ee695243cf5c63e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c516a5986729c70f0a7ca385a41267b73e88694b8d705a3ec7272562c4958d60"
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
  depends_on "utf8proc" if MacOS.version >= :high_sierra

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
