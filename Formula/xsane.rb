class Xsane < Formula
  desc "Graphical scanning frontend"
  homepage "https://gitlab.com/sane-project/frontend/xsane"
  url "https://ftp.osuosl.org/pub/blfs/conglomeration/xsane/xsane-0.999.tar.gz"
  mirror "https://fossies.org/linux/misc/xsane-0.999.tar.gz"
  sha256 "5782d23e67dc961c81eef13a87b17eb0144cae3d1ffc5cf7e0322da751482b4b"
  license "GPL-2.0-or-later"
  revision 5

  livecheck do
    url "https://ftp.osuosl.org/pub/blfs/conglomeration/xsane/"
    regex(/href=.*?xsane[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "f9930b9c1cff8a8d27dd63ca918acf630dbaa535aeed004af7661bc488c2f2a6"
    sha256 arm64_big_sur:  "4e85eef19f06b2cd6607b88cf807ad5bf43e73aa8df991f8685c9c08563bc4b9"
    sha256 monterey:       "f07c97616b20a4861742276aab93018b29f29d666ff87f4bd9695a9068628f72"
    sha256 big_sur:        "bfa40de6ef32772abdc37aabb4729cac4f638e9e67a6da71608331c8f4f2e18a"
    sha256 catalina:       "e00b2638b3cf7906a61118e2b9733ac53fb47aa9889cf86c0d7922908c3578c4"
    sha256 x86_64_linux:   "4e176963eff638e4a2191ca95e032005e252b7c97443408986e87e6d63114bd8"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
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
    # (xsane:27015): Gtk-WARNING **: 12:58:53.105: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "#{bin}/xsane", "--version"
  end
end
