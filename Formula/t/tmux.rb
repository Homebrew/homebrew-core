class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  license "ISC"
  revision 3

  stable do
    # Remove `stable` block in next release.
    url "https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz"
    sha256 "e4fd347843bd0772c4f48d6dde625b0b109b7a380ff15db21e97c11a4dcdf93f"

    # Patch for CVE-2022-47016. Remove in next release.
    # Upstream commit does not apply to 3.3a, so we use Nix's patch.
    # https://github.com/NixOS/nixpkgs/pull/213041
    patch do
      url "https://raw.githubusercontent.com/NixOS/nixpkgs/2821a121dc2acf2fe07d9636ee35ff61807087ea/pkgs/tools/misc/tmux/CVE-2022-47016.patch"
      sha256 "c1284aace9231e736ace52333ec91726d3dfda58d3a3404b67c6f40bf5ed28a4"
    end
  end

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+[a-z]?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2cbeabc833f6195d4dc8c2f01f17f5ae3303a72c769567b6cd57a850ed2e1713"
    sha256 cellar: :any,                 arm64_ventura:  "e93de471a812083476ed413a5ffbe64fbd5597c120c6d00d0c68ba47b74dd1bf"
    sha256 cellar: :any,                 arm64_monterey: "f1da3204877186c49a899e17948e86a03ae827b743f8cb6d7e574d7348bcb0bc"
    sha256 cellar: :any,                 sonoma:         "f84a10a56a5c48c1efce9f83656551e4527c198c8847516099fae838ee319468"
    sha256 cellar: :any,                 ventura:        "0737f0e22e3e533d3c59968bb55e48b920721a56ec4720568d133312c4643a7b"
    sha256 cellar: :any,                 monterey:       "c106e345ad90b3c64c65a5ed60f30a50baafaaa906d8042220beb78177c4a053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43d9d8c0cc2221508fe522a40660ca829a5a0406093ed2b6ddb8012196cbfabe"
  end

  head do
    url "https://github.com/tmux/tmux.git", branch: "master"

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
