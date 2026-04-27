class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.16.10/rtorrent-0.16.10.tar.gz"
  sha256 "ee3cbd8ee95d98b266f6dbef56ce6b566d340955c762dc4c407f45b706ff5733"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "be6a8cca1ebabedf887dcd1eb590d46da47d2d5110885ef702829c1fcc00652a"
    sha256 cellar: :any,                 arm64_sequoia: "3fc0463804de4e7ac367b26463ab630f02321858fbefbff163856e5a1e940618"
    sha256 cellar: :any,                 arm64_sonoma:  "44525eb8683b67081634bf16f2be2ef48bbd4eb639ede555e21ea73023d7b19b"
    sha256 cellar: :any,                 sonoma:        "f0df9cab177271c3aa511180ef821ed5853d4b46f5af20015bba928698058090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53c8f0912b26042c6d8dca10647b05af792ab42e9c1c945907a85982adce202d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "391febee4a2ce24dea6460a75b68afb1cc07561c51d7493d21f2518a188fe58c"
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
