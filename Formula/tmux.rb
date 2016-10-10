class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/2.3/tmux-2.3.tar.gz"
  sha256 "55313e132f0f42de7e020bf6323a1939ee02ab79c48634aa07475db41573852b"
  revision 1

  bottle do
    cellar :any
    sha256 "24d9dbda94c0aa1234789f25f492768b49c67563642233a5d2abbb51fd4e3ad2" => :sierra
    sha256 "417d94c03e60ff396e02a6d6b56ff9be96f0b22127afaa3732ff26d86ed769e3" => :el_capitan
    sha256 "5dbd3539dda1ce33a19dbc9813d005a88d4bef2977af7f40903aae4d9efc5d0c" => :yosemite
  end

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "utf8proc"

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    system "sh", "autogen.sh" if build.head?

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-utf8proc"

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
