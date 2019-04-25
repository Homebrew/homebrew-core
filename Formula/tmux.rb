class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/2.9/tmux-2.9.tar.gz"
  sha256 "34901232f486fd99f3a39e864575e658b5d49f43289ccc6ee57c365f2e2c2980"

  bottle do
    cellar :any
    sha256 "67d13dac99a7db602d062eee405d5f1b7e2add16bb39d8a03a5c0de3504e5683" => :mojave
    sha256 "6b30c67549860286f549f7cbdc88612d9e00a294544ef80fe6c40d098c3805f4" => :high_sierra
    sha256 "52e1fe5132fad335968af1302ad0166247260368fed8b729e73acbead262fab3" => :sierra
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

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    system "sh", "autogen.sh" if build.head?

    args = %W[
      --disable-Dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", *args

    system "make", "install"

    pkgshare.install "example_tmux.conf"
    bash_completion.install resource("completion")
  end

  def caveats; <<~EOS
    Example configuration has been installed to:
      #{opt_pkgshare}
  EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
