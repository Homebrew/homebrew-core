class Sc68 < Formula
  desc "Play music originally designed for Atari ST and Amiga computers"
  homepage "http://sc68.atari.org/project.html"
  url "https://downloads.sourceforge.net/project/sc68/sc68/2.2.1/sc68-2.2.1.tar.gz"
  sha256 "d7371f0f406dc925debf50f64df1f0700e1d29a8502bb170883fc41cc733265f"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/sc68[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "f30cf9999c9d98d9e0c2ecee6b0af0f5f550391ecfbfa51d8f5139dce0aaa0c6"
    sha256 arm64_monterey: "f0f1ad019d6ae62b500fe9395c6e2cc9fe902532c13a2ffef0001763da251433"
    sha256 arm64_big_sur:  "88997849149a628f35a9e44e3abe898c7db9458a796cc61275abfd26923de1bd"
    sha256 ventura:        "f167bb16c498a40a89d35c12447acd1e25ea7a5581b8de6acd483a7384ac41c1"
    sha256 monterey:       "958f47e1b57574ba4ea608fa26a50af67feef92bba51d7e9b598ef0567fb4feb"
    sha256 big_sur:        "d5ac6383a3b1f82707b9a981ca02ce6dee57cdc096adb16dbf044ef5c5a051c9"
    sha256 catalina:       "1d06595617862cdb67d49f8bc8389e7e6cb4bd6f6ac81adf20969c68bbe80434"
    sha256 mojave:         "45e1df25bd1394d7e1985b5fdd96a1090ff82d245f3b26bdc5055ec6c80807dd"
    sha256 high_sierra:    "b3e4809754847ca52468463ed60293032efeecf42f24acd3026bb03d369a91d9"
    sha256 sierra:         "0b5a0931d6f72700ca691436ed69d467cc043aea9b3454d628050886ccd12141"
    sha256 el_capitan:     "d5ac5c810d4f3505230f2cdb9bc3f9f8c14394e1663f30f8d601fe4a559f99c8"
    sha256 x86_64_linux:   "1876d7c98fac9c5a36824c13141354e0cbce33508f155741d8430182d7fd6104"
  end

  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

  def install
    inreplace "configure", "-flat_namespace -undefined suppress",
              "-undefined dynamic_lookup"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
  end

  test do
    # SC68 ships with a sample module; test attempts to print its metadata
    system "#{bin}/info68", "#{pkgshare}/Sample/About-Intro.sc68", "-C", ": ", "-N", "-L"
  end
end
