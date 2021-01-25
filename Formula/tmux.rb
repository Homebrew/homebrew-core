class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.1c/tmux-3.1c.tar.gz"
  sha256 "918f7220447bef33a1902d4faff05317afd9db4ae1c9971bef5c787ac6c88386"
  license "ISC"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+[a-z]?)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "6f9b667c08719ca7a164c571740d510236d55c922058b1d71fb38f66163a394e" => :big_sur
    sha256 "b24cedca1ea1e8e343e5faf6acb509e3df2b3d91b6dcb2934b2c697d8d5b6b07" => :arm64_big_sur
    sha256 "e1148f3043ef1e77e942bc654e6b3867f40401b0ba93e6d44a460467c51e0a3b" => :catalina
    sha256 "3ba85f3524acbf5e1fb04135fa9b7f2bbdd5d3c8ed94189685be50ca19722bbe" => :mojave
    sha256 "ec5fcbdc337221efdbf3f21121fb087b998dd7d3bf6dd5bb72e352d9c9463a57" => :high_sierra
  end

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
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
    system "#{bin}/tmux", "-V"
  end
end
