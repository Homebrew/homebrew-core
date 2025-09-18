class Uade < Formula
  desc "Play Amiga tunes through UAE emulation"
  homepage "https://zakalwe.fi/uade/"
  license "GPL-2.0-only"

  stable do
    url "https://zakalwe.fi/uade/uade3/uade-3.05.tar.bz2"
    sha256 "1a2dd9fdf8cf47c4587dcc09df16f1bb49374a9e7f8f53cdb4816d50c87e4f4c"

    resource "libzakalwe" do
      url "https://gitlab.com/hors/libzakalwe/-/archive/v1.0.0/libzakalwe-v1.0.0.tar.bz2"
      sha256 "cb503c557b04f34069654083963a056deb85a6dea25ba4b69aaaa2bbf7290a98"
    end

    resource "bencode-tools" do
      url "https://gitlab.com/heikkiorsila/bencodetools/-/archive/v1.0.1/bencodetools-v1.0.1.tar.bz2"
      sha256 "e41ae682525cf335b5f5ec0ba9b954abfe7b448e8ed13e2aa2a44e49fce2ca12"
    end
  end

  livecheck do
    url "https://zakalwe.fi/uade/download.html"
    regex(/href=.*?uade[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0f30d852e9fac327855a1871f8b00ffbb476b03d32162be3e7d690982eec541a"
    sha256 arm64_sequoia: "bd88580d311132e6f8989d53759a3f4014c3bd2a799a4beeda45917443bd24b1"
    sha256 arm64_sonoma:  "ebc44bdc2b0985767cfc0e758b626bdc7a4fd25d46fd131f9a345b49f1637170"
    sha256 arm64_ventura: "dd63456268436dad18fad3257239338d9be764a2c65f66a116ec38dc9ad523c7"
    sha256 sonoma:        "8efa9e1dc22e259d2608f0300414f326405fa336fa8bc7323a1894cc9eba424f"
    sha256 ventura:       "c6c24f4dad586bede8ea9cb93103e5b7acdd4694503ffaa00bc66022022c2365"
    sha256 arm64_linux:   "8057cf30b698dd3e7756646839dc75910047f24f7752149e565499f86eed29f0"
    sha256 x86_64_linux:  "57119bf1df980db377ed2a47e16a386060756151ca74a3506bac17685834c4b9"
  end

  head do
    url "https://gitlab.com/uade-music-player/uade.git", branch: "master"

    resource "libzakalwe" do
      url "https://gitlab.com/hors/libzakalwe.git", branch: "master"
    end

    resource "bencode-tools" do
      url "https://gitlab.com/heikkiorsila/bencodetools.git", branch: "master"
    end
  end

  depends_on "pkgconf" => :build
  depends_on "libao"

  def install
    lib.mkdir # for libzakalwe

    resource("libzakalwe").stage do
      # Workaround for Xcode 14.3
      if DevelopmentTools.clang_build_version >= 1403
        inreplace "Makefile", "CFLAGS = -W -Wall", "CFLAGS = -Wno-implicit-function-declaration -W -Wall"
      end

      inreplace "Makefile", "-Wl,-soname,$@", "-Wl"
      system "./configure", *std_configure_args
      system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}"
    end

    resource("bencode-tools").stage do
      system "./configure", "--prefix=#{prefix}", "--without-python"
      system "make"
      system "make", "install"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--libzakalwe-prefix=#{prefix}",
                          "--without-write-audio"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/uade123 --get-info #{test_fixtures("test.mp3")} 2>&1", 1).chomp
    assert_equal "Unknown format: #{test_fixtures("test.mp3")}", output

    assert_match version.to_s, shell_output("#{bin}/uade123 --version")
  end
end
