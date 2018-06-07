class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/2.7/tmux-2.7.tar.gz"
  sha256 "9ded7d100313f6bc5a87404a4048b3745d61f2332f99ec1400a7c4ed9485d452"

  bottle do
    sha256 "673822df46dec9d718fc2b4300fd2b95a261093cf3a256d71286d8fa79c6e4ef" => :high_sierra
    sha256 "79e893ee81d2cd2af20f08aa4ba52297ad24bc9fb2c4d729b61a12f83aa2eec8" => :sierra
    sha256 "a4f05bb40d0c699fac50f053500710d486aaf1ca0cb4fc96e75cb2d4b8461931" => :el_capitan
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
