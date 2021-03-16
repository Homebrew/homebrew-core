class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.10/tintin-2.02.10.tar.gz"
  sha256 "079d316da0d5cfa2d737af647041e54dd00cd1b601a37f2bb127eb80251eaa1a"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d83f015d20e728c68ca04c314949a31f9d5c8c036ee680bf7b928f68acc69899"
    sha256 cellar: :any, big_sur:       "d519dd8c15f67dbc1f8f2d53f5be240d3d2072be570bf8e51c230e36fc186bdf"
    sha256 cellar: :any, catalina:      "c69afb31c206f6551f1009eca62a6f57845b32a89795c5c6e56a6155c86f232b"
    sha256 cellar: :any, mojave:        "aa54bff2eec7ad5b8d4bfc7eac365156a98a84f3304516e2ba919006994dfbe9"
  end

  depends_on "gnutls"
  depends_on "pcre"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tt++ -V", 1)
  end
end
