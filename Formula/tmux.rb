class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/2.9/tmux-2.9.tar.gz"
  sha256 "34901232f486fd99f3a39e864575e658b5d49f43289ccc6ee57c365f2e2c2980"

  bottle do
    cellar :any
    sha256 "f0f683a24fcb3148e0299273f83ca25fb90c7773bbca0672d8736cf82e34f997" => :mojave
    sha256 "d0220b8ad9aa2ffc577b99d7c803198111dc99a0db8d15ca1831a4ef2a6f98c9" => :high_sierra
    sha256 "3c35948e4c5816e760daac4d73a9f40e2d30b8ec5a4022bb2eced3e386e12178" => :sierra
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
