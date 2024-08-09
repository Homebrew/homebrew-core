class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.5.5.tar.gz"
  sha256 "a39b319aa5d46f455e8973cf7f3b6da67f24231dc1c91fdcb3c09e7a689d3c8b"
  license "GPL-3.0-or-later"

  head do
    url "https://www.6809.org.uk/git/xroar.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "texinfo" => :build
  end

  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "sdl2"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", "--without-x", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "XRoar #{version}",
                 shell_output("#{bin}/xroar -V").split("\n").first
  end
end
