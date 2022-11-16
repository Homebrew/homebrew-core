class W3m < Formula
  desc "Pager/text based browser"
  homepage "https://w3m.sourceforge.io/"
  revision 7
  head "https://github.com/tats/w3m.git", branch: "master"

  stable do
    url "https://deb.debian.org/debian/pool/main/w/w3m/w3m_0.5.3.orig.tar.gz"
    sha256 "e994d263f2fd2c22febfbe45103526e00145a7674a0fda79c822b97c2770a9e3"

    # Upstream is effectively Debian https://github.com/tats/w3m at this point.
    # The patches fix a pile of CVEs
    patch do
      url "https://salsa.debian.org/debian/w3m/-/raw/debian/0.5.3-38/debian/patches/010_upstream.patch"
      sha256 "39e80b36bc5213d15a3ef015ce8df87f7fab5f157e784c7f06dc3936f28d11bc"
    end

    patch do
      url "https://salsa.debian.org/debian/w3m/-/raw/debian/0.5.3-38/debian/patches/020_debian.patch"
      sha256 "08bd013064dc544dc2e70599ea1c9e90f18998bc207dd8053188417fbdaeefb2"
    end
  end

  livecheck do
    url "https://deb.debian.org/debian/pool/main/w/w3m/"
    regex(/href=.*?w3m[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "f851decc9866c5d1b0f36e10238e5e6902df0ebf6e782973156b73c178de100d"
    sha256 arm64_monterey: "471292d0ec7637d96304cbb61301909681057dfdf78172ca13f94c2a6f6fc173"
    sha256 arm64_big_sur:  "ca603325cc6d0904d5d709f6e9407b26fd22e3eeb3984d38e11c21d8f45e7b3a"
    sha256 ventura:        "10c3e54ffe89466494165ebaba21b691778cd14e10e40a49550034dde9de7b57"
    sha256 monterey:       "5e8f410d2f2942a76602d88a71eee516e43d21164e0e1e41855827ae6f226fa0"
    sha256 big_sur:        "9865fb7a43e8732bb7d309502c3de3410d05aeb093ba8916462b5aab36563a5a"
    sha256 catalina:       "5b752461983a608c684bae9efa13a0a5e37a456def0b368c8b0706b35fd480a3"
    sha256 mojave:         "a77f9a7ceee4dbb2a7288ecfad9c903c489ce4a60ff10056cd735433986df901"
    sha256 x86_64_linux:   "425cc2d1f5e1c4dff0f4f70c916322e55e95d50b18a003c9ff065cb982fc90e9"
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "openssl@1.1"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gettext"
    depends_on "libbsd"
  end

  def install
    # Work around configure issues with Xcode 12
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-image",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match "DuckDuckGo", shell_output("#{bin}/w3m -dump https://duckduckgo.com")
  end
end
