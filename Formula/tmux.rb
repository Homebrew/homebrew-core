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
    sha256 cellar: :any,                 arm64_monterey: "6f0331120c7069f6087bfeb423f03ebd6066d7a8069804dee43c935ad2f41f61"
    sha256 cellar: :any,                 arm64_big_sur:  "c1600c185934c9977a7da4dbe465cc91c2cc9a18581b95fbffd6b54186480fbf"
    sha256 cellar: :any,                 monterey:       "186ebfae5c6dd36efce4c7fc9cda6c922bcc2df29bc13878c993f9a44bfc5029"
    sha256 cellar: :any,                 big_sur:        "f9b89e64ed341c98a9b5c8d00935140dfd92dfd38e54d50931e6995b3fdf73d9"
    sha256 cellar: :any,                 catalina:       "e12d0599f3fe24e1c556966739ad52b7ee84c7cc92c21f0cc6a378fc5c19c78c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5e292aa2bd7dbf7234ca308f82915af23edf5215dacaa1c515c26d425ad3529"
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

  def post_install
    if OS.mac? && !(etc/"tmux.conf").exist?
      (etc/"tmux.conf").write <<~EOS
        set -g default-terminal screen-256color
      EOS
    end
  end

  def caveats
    <<~EOS
      Example configuration has been installed to:
        #{opt_pkgshare}

      On macOS, add the following to etc/tmux.conf or ~/.tmux.conf
        set -g default-terminal screen-256color
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
