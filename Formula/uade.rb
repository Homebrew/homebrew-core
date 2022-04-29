class Uade < Formula
  desc "Play Amiga tunes through UAE emulation"
  homepage "https://zakalwe.fi/uade/"
  license "GPL-2.0-only"

  stable do
    url "https://zakalwe.fi/uade/uade3/uade-3.01.tar.bz2"
    sha256 "a669c215970db2595027c16ee01149613fcfa4b81be67216ce6d7add871ef62a"

    resource "bencode-tools" do
      url "https://gitlab.com/heikkiorsila/bencodetools.git", revision: "5a1ccf65393ee50af3a029d0632f29567467873c"
    end
  end

  livecheck do
    url "https://zakalwe.fi/uade/download.html"
    regex(/href=.*?uade[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "48b10be71fbfe1eae3271539e13c4e6177536f7fe69758ec1994ba383e37c14e"
    sha256 arm64_big_sur:  "44ebe9c6fddd5da6043eccad2c2cca7a55862d4b020b348ab579b88125e43938"
    sha256 monterey:       "7754843e8901b84c0434b1a714b5c8f3cabb3831dcf1b34fde13a5a57275fe1c"
    sha256 big_sur:        "f3df21df8b0f5533248f1a23323c24ce9933b1500bb8b15f26bb430385d05f95"
    sha256 catalina:       "10471b0c0ebb1fc05ed2cec2268aac9727110312b5e2ab20202bdbf9ce98a198"
    sha256 mojave:         "c3fec98e439e93b609a93b3041a0e09be74426652b5dd78f15c543afeeb4216d"
    sha256 high_sierra:    "226dc1fbb9535b64f19e04310db19fb9a760024fc0b0c73e3c68cf7c72e508d9"
    sha256 sierra:         "432a5f95b33416c9bfc29ef4d81ea6d4fab2a568c71c00a9bda034985ed1276b"
    sha256 el_capitan:     "59ddaa5a6d841f436a5d297330ff62b613e446785ad17666c8fb4157d3a7c8db"
    sha256 yosemite:       "454945f35580b0b2bc8f0c7ddeecfae091634f54ee3a367eb14acce7251e5779"
    sha256 x86_64_linux:   "4e9995eda253cbfa248aa486080c04cca295f348e1682d2c10b7ec45a967d46f"
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
