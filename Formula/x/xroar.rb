class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.13.1.tar.gz"
  sha256 "75251696df8053d2fd6c02c30fc6f02506f074dbf9cc2fc6eaf2183a3739be7c"
  license "GPL-3.0-or-later"

  bottle do
    manifest_sha256 "ef9a56d7c18fd19d2e2bbb49bae189f109d7a349c4136cf21a7db7ae4723841d"
    sha256 cellar: :any, arm64_golden_gate: "907102152aca4756e8de67a34cad2c3680bed7114a922811bbd8cc99ab99402a"
    sha256 cellar: :any, arm64_tahoe:       "9311a78f485ab94417bff88fece1997147012afefe0b913c85d92cdbda06756f"
    sha256 cellar: :any, arm64_sequoia:     "8a6aeaf56d22e4428a8cbe54046a1753f731a4b9c874eb3410d940d16884ae56"
    sha256 cellar: :any, arm64_linux:       "4c651acfa66e4d6c4905f3f5c1c599444781528cc206e1f021db070941a81951"
    sha256 cellar: :any, x86_64_linux:      "6ef152807a40a61029abfc231808fcfe3c07372ef32923430823ff1eb199b8b0"
  end

  head do
    url "https://www.6809.org.uk/git/xroar.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "texinfo" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "sdl2-compat"

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./autogen.sh" if build.head?
    # Keep SDL3 from being selected through sdl2-compat's transitive dependency.
    system "./configure", "--disable-silent-rules", "--without-x", "--with-sdl2", *std_configure_args
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
