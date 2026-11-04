class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.27/rtorrent-0.16.27.tar.gz"
  sha256 "645e5ea863fee2c3a0f745be6235a37e80cf7db6a07bc82ca31d49bf65f2a52a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8b4390c3dbcdda7c242a9bf8af339afb38969b450741cb9d94dac5d2dcb64282"
    sha256 cellar: :any, arm64_tahoe:       "af89b562b20f9a41f3fe14621da1bbed1f53928b6f13668b64c59ce4e8a4ba05"
    sha256 cellar: :any, arm64_sequoia:     "e0d37d9003ecfdb6e6d1e9cb6793e01c2f328d312098b26289dbcf6a2188c420"
    sha256 cellar: :any, arm64_linux:       "d61916491008cbfeb460b09418512e590924680ba6ce49aaa79f15812b6f0d3a"
    sha256 cellar: :any, x86_64_linux:      "0890319ab9cfd42ee705fa928502a3937543284531b0ca17a5cad145024124c9"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "libtorrent-rakshasa"
  depends_on "xmlrpc-c"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--with-xmlrpc-c", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    pid = spawn bin/"rtorrent", "-n", "-s", testpath
    sleep 10
    assert_path_exists testpath/"rtorrent.lock"
  ensure
    Process.kill("HUP", pid)
  end
end
