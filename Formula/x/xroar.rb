class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.12.1.tar.gz"
  sha256 "ba525225fbd732c4dbf2cbb571dc9d2810fd9dcedf0482133cf637e2eef61f88"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "45fc17a5ef64c9f5d03568ab92be47a74f2e063445e22ea7b080216c10616b02"
    sha256 cellar: :any, arm64_sequoia: "3ce570ced666937ec8de3b7cd32a1365cf1856954e4ab7c9eb518ff000ea83bb"
    sha256 cellar: :any, arm64_sonoma:  "e73e983da1247571d0d820fff89dcb0838992c0b902becc7b6cdb72453bc8a83"
    sha256 cellar: :any, sonoma:        "0541fa0834dfdbcf8a72f3dbf1367b0649b335a32e03f6a5600f9e4bb33f5660"
    sha256 cellar: :any, arm64_linux:   "f21256affa2a7f37611b453f19249adce26768f650eee897d64f722d66b3617f"
    sha256 cellar: :any, x86_64_linux:  "db0cc1aeeaa264958470c4da85d1a17bbee5a28068510fb7a6f399e2c3a62b41"
  end

  head do
    url "https://www.6809.org.uk/git/xroar.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "texinfo" => :build
  end

  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "sdl2-compat"

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "zlib-ng-compat"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", "--without-x", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/xroar -config-print")

    assert_match(/machine dragon32/, output)
    assert_match(/machine dragon64/, output)
    assert_match(/machine tano/, output)
    assert_match(/machine dragon200e/, output)
    assert_match(/machine coco/, output)
    assert_match(/machine cocous/, output)
    assert_match(/machine coco2b/, output)
    assert_match(/machine coco2bus/, output)
    assert_match(/machine coco3/, output)
    assert_match(/machine coco3p/, output)
    assert_match(/machine mx1600/, output)
    assert_match(/machine mc10/, output)
    assert_match(/machine alice/, output)
  end
end
