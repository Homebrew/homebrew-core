class Zboy < Formula
  desc "GameBoy emulator"
  homepage "https://zboy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/zboy/zBoy%20v0.71/zboy-0.71.tar.xz"
  sha256 "d359b87e3149418fbe1599247c9ca71e870d213b64a912616ffc6e77d1dff506"
  license "GPL-3.0-or-later"
  head "https://svn.code.sf.net/p/zboy/code/trunk"

  livecheck do
    url :stable
    regex(%r{url=.*?/zboy[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "6a88b48f0f07f47bea0da0a31aee45ba535c2f9afc3a612a859c68b322db3e0d"
    sha256 cellar: :any,                 arm64_sequoia:  "cb8335a141f8e9a964288509aa204bee9b9a1672286ce0c97e236af7c8afc6a6"
    sha256 cellar: :any,                 arm64_sonoma:   "16735e77d0184557a36d147ba19935ef2ddf048a6cad3d63efe90c72065a8c4c"
    sha256 cellar: :any,                 arm64_ventura:  "4c1255995acd35d950d0625b1c505b32feeb5f92ba8428e5a91405aca49f5841"
    sha256 cellar: :any,                 arm64_monterey: "19932605bd410edb2aa29dca7ee24442f62323f35118faee2132434a68cf891f"
    sha256 cellar: :any,                 arm64_big_sur:  "3ca2df4138ab68a6124473e973ac17161cbb8850388c21cf768008f204361eb6"
    sha256 cellar: :any,                 sonoma:         "e0b8bbd2f090406aa2c67b4b3dd1ade28c8007f1b5b96552134e534d50652e37"
    sha256 cellar: :any,                 ventura:        "1770fc751708bba11c935142cf5d51ebcda11a816b9d183c270df6b11b52601f"
    sha256 cellar: :any,                 monterey:       "e2f20de36150fd9ebb743bf9302083bc75960b6b2760f90b07071475bedc0ba2"
    sha256 cellar: :any,                 big_sur:        "932d9411d6f5119849d230a6747e7bd65cade0d64c80128ea2ffee8096797dd2"
    sha256 cellar: :any,                 catalina:       "9e143e9227bc22e48d66f7e9f3239374d4d22edc4d0867ffe50f8f60180d27db"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "21f25a5ddc14d43b31ce8bbceff130e74252568f856359be2e99d3179b1cee8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2baaf6491fe70279c22f669b2a64bd5467506ea9be7aa86807a06519f0b9311"
  end

  depends_on "sdl2"

  def install
    sdl2 = Formula["sdl2"]
    ENV.append_to_cflags "-std=gnu89 -D__zboy4linux__ -DNETPLAY -DLFNAVAIL -I#{sdl2.include} -L#{sdl2.lib}"
    inreplace "Makefile.linux", "zboy.o", "zboy.o drv_sdl2.o"
    system "make", "-f", "Makefile.linux", "CFLAGS=#{ENV.cflags}"
    bin.install "zboy"
  end

  test do
    system bin/"zboy", "--help"
  end
end
