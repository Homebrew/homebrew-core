class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/2.9a/tmux-2.9a.tar.gz"
  sha256 "839d167a4517a6bffa6b6074e89a9a8630547b2dea2086f1fad15af12ab23b25"
  revision 1

  bottle do
    cellar :any
    sha256 "9479fe351b5e6165ac6c50b6cdd393afa84fc35e908696a6b0410f2f8cf8dd01" => :catalina
    sha256 "a6c847ffc57c9e6d730b1dcfb3ca193588cfdb679a60f221a41690ac8ec202a7" => :mojave
    sha256 "c01b0af8cf9a266e4ced0aaa6c05bd9c83b69b22ea9c790f0ab38eec4d86fcbf" => :high_sierra
    sha256 "caeb4047951019c086ddbb8d0ace71b3f62e7266decd2b06c28f0213897292b4" => :sierra
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
