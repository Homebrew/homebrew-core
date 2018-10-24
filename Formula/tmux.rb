class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/2.8/tmux-2.8.tar.gz"
  sha256 "7f6bf335634fafecff878d78de389562ea7f73a7367f268b66d37ea13617a2ba"

  bottle do
    sha256 "1853b704405374f88dcb00ef4c82c18efbcbac2ce855de681bd7017c3b5e6b36" => :mojave
    sha256 "b50d0ac39ae8219d84b9fba7ae5f0422143d8a7a9575b9193d7604dc1b3a85f0" => :high_sierra
    sha256 "d4b259196136dfb9fe4cf68a348d68edc58ac2b6d0954fe60c6694b053826cd3" => :sierra
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

  def caveats; <<~EOS
    Example configuration has been installed to:
      #{opt_pkgshare}
  EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
