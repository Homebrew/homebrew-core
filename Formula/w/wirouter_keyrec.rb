class WirouterKeyrec < Formula
  desc "Recover the default WPA passphrases from supported routers"
  homepage "https://www.salvatorefresta.net/tools/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/wirouterkeyrec/WiRouter_KeyRec_1.1.2.zip"
  mirror "https://distfiles.macports.org/wirouterkeyrec/WiRouter_KeyRec_1.1.2.zip"
  sha256 "3e59138f35502b32b47bd91fe18c0c232921c08d32525a2ae3c14daec09058d4"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(%r{href=.*?/WiRouter_KeyRec[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "34e5fd2a6a9e60936a2618fd84b435911d6ec1f1f53bb66180ec884077b482cb"
    sha256 arm64_sequoia:  "cccb46ddcd0b30219ed24a351f2dfb1dacf796da3fdabe377b2d9300db62bf1d"
    sha256 arm64_sonoma:   "86c53e8b3f2532c768bb13ae50bd272e3b55866a674c3bf7aa9c370c80ab6084"
    sha256 arm64_ventura:  "d0f76ae3936a32cc3be17614e325503686400bd1c38abf3a072d0f0de9444628"
    sha256 arm64_monterey: "43c8cb4e4f1389c6a584c27b0407c11e31422cdb2802706f316a93f7e5d8c7a5"
    sha256 arm64_big_sur:  "e3cfa2752a3957af0fcc474d4ad24ab76f026ee4479e0fa74d84222d16c02812"
    sha256 sonoma:         "768f3df3b16cbd2bc7ecd3eb65b5d7da4d302d21f78076657af195b36a5c7e81"
    sha256 ventura:        "e0334033e6d6ac7f366a556d8e89d3394bc85968180e52ef7bc5ad4edcfa2548"
    sha256 monterey:       "0b4c56b39f76881732a5afd3a4fc490e35e05145efb71845d938555d1173168d"
    sha256 big_sur:        "f5a1ec8cb71d5240eb01a3dbd0cbfa8f09c4b76cae27cacd2fea058ccb8c9f78"
    sha256 catalina:       "907d4ed63f0f9c13217a9120749b12521ad773d310d554534a507ca9714d2dd7"
    sha256 arm64_linux:    "2fe4fe43878fd795923cf6577d4ac268e26c7d1612ed6700e201592bb9878fb0"
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
    system bin/"wirouterkeyrec", "-s", "Alice-12345678"
  end
end
