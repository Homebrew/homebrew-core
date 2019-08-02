class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/2.9a/tmux-2.9a.tar.gz"
  sha256 "839d167a4517a6bffa6b6074e89a9a8630547b2dea2086f1fad15af12ab23b25"
  revision 1

  bottle do
    cellar :any
    sha256 "39e422362b56750f805e9725c498fd5653987a26e1b892d5f0d40820616be69d" => :mojave
    sha256 "5c7148b6beb43995a0f53504f9a3f0500420e5ad11e17f34ce60401f42b833df" => :high_sierra
    sha256 "b59dc70fea0e69398d757e5212d5d21642ee552518af5870f789312465c88500" => :sierra
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
