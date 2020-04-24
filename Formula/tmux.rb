class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.1/tmux-3.1.tar.gz"
  sha256 "979bf38db2c36193de49149aaea5c540d18e01ccc27cf76e2aff5606bd186722"

  bottle do
    cellar :any
    sha256 "d83b378969a8af595451db10bf4b8eb251a8ed4217cb13e161b3dbe20330d1f8" => :catalina
    sha256 "4acca70a1bba7bb762081015373c438a930af6a6b28e9e1409c4b84ae78ad514" => :mojave
    sha256 "bc934e88baba7f0549c3b5916ed19211764ecaf6c95e46624c2f641b631abdb9" => :high_sierra
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
  depends_on "utf8proc"

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    system "sh", "autogen.sh" if build.head?

    args = %W[
      --enable-utf8proc
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

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
