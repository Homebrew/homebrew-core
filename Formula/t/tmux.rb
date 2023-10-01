class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  license "ISC"
  revision 2

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
    sha256 cellar: :any,                 arm64_sonoma:   "a3e273ee4ccfaeb5035b37cb361338c92a92a472bb87f19e1740f24148d3795f"
    sha256 cellar: :any,                 arm64_ventura:  "cf149268a57056eaa65e5c238668fc818caf5850a604b02e019ca3017184e731"
    sha256 cellar: :any,                 arm64_monterey: "e5b94436fc6bb4b2b60b9ccb8b0dfa7dc66429a148a68afd8250f1af4d963544"
    sha256 cellar: :any,                 arm64_big_sur:  "c7ceb9e78083537f4c7fcf3a22e620c1f0f03bea65573cb7660ecacd61d91004"
    sha256 cellar: :any,                 sonoma:         "c1b69eabc58e5a23984cf9c862ba857dd9725e641a7fe056a430d1b2153a524d"
    sha256 cellar: :any,                 ventura:        "5d9f6bfa55bd892f0d79acd5d8513e31553493267add167b0f195354ed0bd0ab"
    sha256 cellar: :any,                 monterey:       "a24369c3d46641aa541f6a791bb23aa3e2fb91f3768086be6e9934af7bca5e74"
    sha256 cellar: :any,                 big_sur:        "48055e1e39515db54922c2068d4da9800724727786763f9b4af198e13a44a75d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aec481263694618cf74e6c9b7e7208d828a46f45071226e7a6ac6af62f46a036"
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

    # tmux finds the `tmux-256color` terminfo provided by our ncurses
    # and uses that as the default `TERM`, but this causes issues for
    # tools that link with the very old ncurses provided by macOS.
    # https://github.com/Homebrew/homebrew-core/issues/102748
    args << "--with-TERM=screen-256color" if OS.mac?
    args << "--enable-utf8proc" if MacOS.version >= :high_sierra || OS.linux?

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
