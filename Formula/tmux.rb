class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"

  stable do
    url "https://github.com/tmux/tmux/releases/download/2.2/tmux-2.2.tar.gz"
    sha256 "bc28541b64f99929fe8e3ae7a02291263f3c97730781201824c0f05d7c8e19e4"

    patch do
      # required for the following patch
      url "https://github.com/tmux/tmux/commit/d303e5.patch"
      sha256 "a3ae96b209254de9dc1f10207cc0da250f7d5ec771f2b5f5593c687e21028f67"
    end

    patch do
      # workaround for bug in system unicode library reporting negative width
      # for some valid characters
      url "https://github.com/tmux/tmux/commit/23fdbc.patch"
      sha256 "7ec4e7f325f836de5948c3f3b03bec6031d60a17927a5f50fdb2e13842e90c3e"
    end
  end

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"

  resource "completion" do
    url "https://raw.githubusercontent.com/przepompownia/tmux-bash-completion/v0.0.1/completions/tmux"
    sha256 "a0905c595fec7f0258fba5466315d42d67eca3bd2d3b12f4af8936d7f168b6c6"
  end

  def install
    system "sh", "autogen.sh" if build.head?

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"

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
