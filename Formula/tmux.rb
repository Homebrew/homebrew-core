class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/2.6/tmux-2.6.tar.gz"
  sha256 "b17cd170a94d7b58c0698752e1f4f263ab6dc47425230df7e53a6435cc7cd7e8"

  bottle do
    sha256 "0ca2e76822980dcc009fde38379f7546b6568975d9dc4f2a6a312e32fce186f8" => :high_sierra
    sha256 "d2b71640c44c4fc1e953a6eb1ca14b8c91ee4a19a91f2f699546c5cd6ed5b302" => :sierra
    sha256 "cda9003fa113251c024210750d529be80379288436cf66a67a3896d2d14b6766" => :el_capitan
  end

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "utf8proc" => :optional

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

    args << "--enable-utf8proc" if build.with?("utf8proc")

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", *args

    system "make", "install"

    pkgshare.install "example_tmux.conf"
    bash_completion.install resource("completion")
  end

  def caveats; <<-EOS.undent
    Example configuration has been installed to:
      #{opt_pkgshare}
    EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
