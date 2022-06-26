class WirouterKeyrec < Formula
  desc "Recover the default WPA passphrases from supported routers"
  homepage "https://www.salvatorefresta.net/tools/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/wirouterkeyrec/WiRouter_KeyRec_1.1.2.zip"
  mirror "https://distfiles.macports.org/wirouterkeyrec/WiRouter_KeyRec_1.1.2.zip"
  sha256 "3e59138f35502b32b47bd91fe18c0c232921c08d32525a2ae3c14daec09058d4"
  license "GPL-3.0"

  livecheck do
    url :homepage
    regex(%r{href=.*?/WiRouter_KeyRec[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_monterey: "43c8cb4e4f1389c6a584c27b0407c11e31422cdb2802706f316a93f7e5d8c7a5"
    sha256 arm64_big_sur:  "e3cfa2752a3957af0fcc474d4ad24ab76f026ee4479e0fa74d84222d16c02812"
    sha256 monterey:       "0b4c56b39f76881732a5afd3a4fc490e35e05145efb71845d938555d1173168d"
    sha256 big_sur:        "f5a1ec8cb71d5240eb01a3dbd0cbfa8f09c4b76cae27cacd2fea058ccb8c9f78"
    sha256 catalina:       "907d4ed63f0f9c13217a9120749b12521ad773d310d554534a507ca9714d2dd7"
    sha256 mojave:         "ca8371cae9a6a4ce5ce4541a811d17260d877695426b16777e4b89d0fb912332"
    sha256 high_sierra:    "60a9b2a5fffe6027b296ad5b320377dd98a28658b628d6b3acbe94126e54ff3e"
    sha256 sierra:         "2accae4664406559e45909d53eaf6a8a8569773c8e0d932e2d3a8090706f8f18"
    sha256 el_capitan:     "3982522d8e15ced547c4f1d3019fe3ca6ddaa88d33fad03d2c97a53c849ec217"
    sha256 yosemite:       "65d21ba4cb167dd2cca395dd5b51edc1ddd0df06fc65843cd2d2eba9e307ea11"
    sha256 x86_64_linux:   "1d3f91f6d9f53dda66211c8d0f01081e92a1b43dbbb98b2cabfb63d337cb7eea"
  end

  def install
    inreplace "src/agpf.h", %r{/etc}, "#{prefix}/etc"
    inreplace "src/teletu.h", %r{/etc}, "#{prefix}/etc"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{prefix}",
                          "--exec-prefix=#{prefix}"
    system "make", "prefix=#{prefix}"
    system "make", "install", "DESTDIR=#{prefix}", "BIN_DIR=bin/"
  end

  test do
    system "#{bin}/wirouterkeyrec", "-s", "Alice-12345678"
  end
end
