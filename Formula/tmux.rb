class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"

  stable do
    url "https://github.com/tmux/tmux/releases/download/2.3/tmux-2.3.tar.gz"
    sha256 "55313e132f0f42de7e020bf6323a1939ee02ab79c48634aa07475db41573852b"
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "c7deb6acadd39da0789b02c11f83780d1b0328cdcc70f89be268a059bab72fd0" => :sierra
    sha256 "627aef14033e462ffd4694dcc052eca01d8e3b13e6db5bad9717643c9e342ff1" => :el_capitan
    sha256 "e566bb8605da1ee8aa001730c2a17f2082b39e2a949cce3502b3100a6c621878" => :yosemite
    sha256 "caa0bdef33a828985dc507fa1206a3cafe8677e55a4df2ecf8434e37693afd71" => :mavericks
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
