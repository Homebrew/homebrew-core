class Xsane < Formula
  desc "Graphical scanning frontend"
  homepage "https://wiki.ubuntuusers.de/XSane/"
  url "https://ftp.osuosl.org/pub/blfs/conglomeration/xsane/xsane-0.999.tar.gz"
  mirror "https://fossies.org/linux/misc/xsane-0.999.tar.gz"
  sha256 "5782d23e67dc961c81eef13a87b17eb0144cae3d1ffc5cf7e0322da751482b4b"
  revision 4

  livecheck do
    url "https://ftp.osuosl.org/pub/blfs/conglomeration/xsane/"
    regex(/href=.*?xsane[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "9b9d063702e8b647286c8fa1fdfdd67bddf442248c6c41eb10a6b4c5f73865a1"
    sha256 arm64_big_sur:  "716cd7c1b0cf30e363953817aab54187e9bb5f7dcba2cb74f03bc06b3e3c7d72"
    sha256 monterey:       "510446e88d36d104aa1e30cf08a7445ffba12c3280ea3dee90232a91da4bfbe3"
    sha256 big_sur:        "1908941949c06e32e9185ea8e069454bd1946110670362ab9e46de7687258a2e"
    sha256 catalina:       "1b87500430dca49d717fa39d92214da59f08d4f7ec63ea477056bc5b2b920de4"
    sha256 mojave:         "93064b6ec70657f6815a0aba5d52c8b7e54e9ef6f223c608351b790887c62b92"
    sha256 high_sierra:    "4242d28d56f5ed634f7f8632d41e441e1cbeaf60a362628796a436ba2f8eac11"
    sha256 sierra:         "f247067d49d44f8c0662cd64c99524f13c4b3a18ef7e49a19dd377bb449c859d"
    sha256 x86_64_linux:   "133b3933b827ee30467074ccda832be05c14563290f83cb3e829ac25c088a5dc"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "sane-backends"

  # Needed to compile against libpng 1.5, Project appears to be dead.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e1a592d/xsane/patch-src__xsane-save.c-libpng15-compat.diff"
    sha256 "404b963b30081bfc64020179be7b1a85668f6f16e608c741369e39114af46e27"
  end

  def install
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration" if OS.mac?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    on_linux do
      # (xsane:27015): Gtk-WARNING **: 12:58:53.105: cannot open display
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system "#{bin}/xsane", "--version"
  end
end
