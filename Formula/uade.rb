class Uade < Formula
  desc "Play Amiga tunes through UAE emulation"
  homepage "https://zakalwe.fi/uade/"
  license "GPL-2.0-only"

  stable do
    url "https://zakalwe.fi/uade/uade3/uade-3.02.tar.bz2"
    sha256 "2aa317525402e479ae8863222e3c341d135670fcb23a2853ac93075ac428f35b"

    resource "bencode-tools" do
      url "https://gitlab.com/heikkiorsila/bencodetools.git", revision: "5a1ccf65393ee50af3a029d0632f29567467873c"
    end
  end

  livecheck do
    url "https://zakalwe.fi/uade/download.html"
    regex(/href=.*?uade[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "fa9a21970736350b0dbc4c4d0f5369cfae10228e085ba47f319825bd63d90b79"
    sha256 arm64_big_sur:  "1b683bf82cf23de3c10ec86efbe4703f71d5b169bd5584ed2247ac01985956fa"
    sha256 monterey:       "32051055d28f58edf35569342c247d64f14a9bae6b9d8eade309ccd6ba935ec8"
    sha256 big_sur:        "b1be2325472e12eccaac8edf503db68c5e4f9c8425e4b26c4bf184e4a0ee7ee8"
    sha256 catalina:       "238f1f6d010744cf7b4a431535a773fe08d1f8677c1b76d2af3ed186a2a65d7c"
    sha256 x86_64_linux:   "d491f6af721e44247fcb95c8977cdbbb38ae0222ea06d3e2d7df83edea687632"
  end

  head do
    url "https://gitlab.com/uade-music-player/uade.git", branch: "master"

    resource "bencode-tools" do
      url "https://gitlab.com/heikkiorsila/bencodetools.git", branch: "master"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "libao"

  def install
    resource("bencode-tools").stage do
      system "./configure", "--prefix=#{prefix}", "--without-python"
      system "make"
      system "make", "install"
    end

    system "./configure", "--prefix=#{prefix}",
           "--without-write-audio"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/uade123 --get-info #{test_fixtures("test.mp3")} 2>&1", 1).chomp
    assert_equal "Unknown format: #{test_fixtures("test.mp3")}", output
  end
end
