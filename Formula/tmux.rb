class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"

  stable do
    url "https://github.com/tmux/tmux/releases/download/2.2/tmux-2.2.tar.gz"
    sha256 "bc28541b64f99929fe8e3ae7a02291263f3c97730781201824c0f05d7c8e19e4"
  end

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"

  def install
    system "sh", "autogen.sh" if build.head?

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"

    system "make", "install"
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
