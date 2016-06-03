class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"

  stable do
    url "https://github.com/tmux/tmux/releases/download/2.2/tmux-2.2.tar.gz"
    sha256 "bc28541b64f99929fe8e3ae7a02291263f3c97730781201824c0f05d7c8e19e4"

    patch do
      # required for the following unicode patch
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

  bottle do
    cellar :any
    sha256 "0104097d7a1578ddaca6b41ed98cd8014ab19b36f99e116a47fddf9ffccb7fef" => :el_capitan
    sha256 "5aff2ce4b973ca19ca8ccbab0a199f7e2a6132a7e8851211bb7fac0538dd52d2" => :yosemite
    sha256 "f8583ee2f6511469ac2c6f46db92782d4db3e0385cb0bcbd1b88a97bfbef9caf" => :mavericks
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
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
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
