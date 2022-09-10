class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.6.1.tar.gz"
  sha256 "20df84c851aaf2f5000510927f6d31b32f269916d351465c366dc0afc9dc150c"
  license "GPL-2.0-or-later"
  revision 2
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  livecheck do
    url :stable
    regex(%r{url=.*?/vice[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "ec197d9fc5fd92223d1ce67cbbfa6b7d48e197676196f3735bb676e9b5a1dadb"
    sha256 arm64_big_sur:  "e7eaefdc8b8c7928be08a75911d80f81e829f77bbf0976ed2f7ffa4eac8bf42a"
    sha256 monterey:       "5b4c1956224144e96e6528395b1f13859dd4913e97aa3c65cd119b47771c6c7f"
    sha256 big_sur:        "f52aae79c46313cd316b16255e0fa2e482292eca2cac1e1b2361eccd3aae9705"
    sha256 catalina:       "f633c31bf15b63f837fdbbd168e43375866add38c03e6dc7235da095c339f9c7"
    sha256 x86_64_linux:   "53cb0864d4bde5529b7a4e521a63018be0fed4aa8adf912c577f2703cdd41b3f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "dos2unix" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build

  depends_on "adwaita-icon-theme"
  depends_on "ffmpeg@4"
  depends_on "flac"
  depends_on "giflib"
  depends_on "glew"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libvorbis"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-arch",
                          "--disable-pdf-docs",
                          "--enable-native-gtk3ui",
                          "--enable-midi",
                          "--enable-lame",
                          "--enable-external-ffmpeg",
                          "--enable-ethernet",
                          "--enable-cpuhistory",
                          "--with-flac",
                          "--with-vorbis",
                          "--with-gif",
                          "--with-jpeg",
                          "--with-png"
    system "make", "install"
  end

  test do
    assert_match "Initializing.", shell_output("#{bin}/x64sc -console -limitcycles 1000000 -logfile -", 1)
  end
end
