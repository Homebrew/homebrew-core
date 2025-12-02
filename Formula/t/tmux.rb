class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.6/tmux-3.6.tar.gz"
  sha256 "136db80cfbfba617a103401f52874e7c64927986b65b1b700350b6058ad69607"
  license "ISC"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+[a-z]?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "838ab4b9a210d21f675f305973182190e114923d0152654fad1ab14d41576383"
    sha256 cellar: :any,                 arm64_sequoia: "85a363182b7f5399e5f1a95d77275c77d6621977d5bc9aaf00164f8110894ac0"
    sha256 cellar: :any,                 arm64_sonoma:  "3ffa71900ea340a251822f2bd8ad079a12ea73aed913bebb1962ef7d65df75a7"
    sha256 cellar: :any,                 sonoma:        "45816702ec8f9cd79af5f4208bb710c5649aaa4df413b831e2cb817c40f33b24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dcdc8b9aebe530d3de56e1853ac550a3895781e10e527681dbb746ce4bd3f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "141896e0f6f8f80631065d41f07acce86593d42c931e5671f8788723d7f290b8"
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

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/8da7f797245970659b259b85e5409f197b8afddd/completions/tmux"
    sha256 "4e2179053376f4194b342249d75c243c1573c82c185bfbea008be1739048e709"
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
    PTY.spawn bin/"tmux", "-S", socket, "-f", File::NULL
    sleep 10

    assert_path_exists socket
    assert_predicate socket, :socket?
    assert_equal "no server running on #{socket}", shell_output("#{bin}/tmux -S#{socket} list-sessions 2>&1", 1).chomp
  end
end
