class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.1a/tmux-3.1a.tar.gz"
  sha256 "10687cbb02082b8b9e076cf122f1b783acc2157be73021b4bedb47e958f4e484"

  bottle do
    cellar :any
    sha256 "ce07fcb82823ad832cf612a5b090a71167530c901b5b492b210ea59dc72dbb77" => :catalina
    sha256 "2861e30ca8481af9b0c09ab0e5d156b10b0daf3c0aca07da1cb77522c7c796aa" => :mojave
    sha256 "0c38f3532fd15148d54cb3e1ed13f60fb39dd5e3d4f6a68d8903f7e5ecf9d868" => :high_sierra
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
