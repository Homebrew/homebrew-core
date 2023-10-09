class Xsw < Formula
  desc "Slide show presentation tool"
  homepage "https://code.google.com/archive/p/xsw/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/xsw/xsw-0.3.5.tar.gz"
  sha256 "d7f86047716d9c4d7b2d98543952d59ce871c7d11c63653f2e21a90bcd7a6085"
  license "GPL-3.0"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "30a80c0aafb3e808ebe486a79d5fbed46c76e648406525d91618aeee3157ee72"
    sha256 arm64_ventura:  "3ba2080f806861639a5c6ed065feb576c5e6483f5cb4e30164a63f3dec4888d0"
    sha256 arm64_monterey: "1a4a635c11df035cdb3aaf70265cf88ab821c3778ae20679728921bba4b49bf5"
    sha256 arm64_big_sur:  "adcd51d55c60f71ad81dc0c88cc67dac046d4083d7c27b50e0d4cfd9fdc8ff2b"
    sha256 sonoma:         "b48f864041c383879404171865d3e1b583b3631160da9e12d461cf46aaf39719"
    sha256 ventura:        "6e5b6a41cf51b3ac1fae18822302c789d43778b6e69235cd39c987b30e122b02"
    sha256 monterey:       "7f101f339ccf764f1fca2b4e81a227cd4e1861a06d4c1630a8f9ac3aa9ca9c0c"
    sha256 big_sur:        "89b5bea34cf3c25385f810ce2c4bf667cd43caf541316d8efc47958d1f404847"
    sha256 catalina:       "151199c2df40c292c4c0751cdf385d6d59704a98100be61eb3111e3429d31b04"
    sha256 x86_64_linux:   "85ae0378112fd3d6d2307c9bbc1506896f1d534ddc26d8dc04fcc122a7617668"
  end

  # Last release on 2009-05-09
  deprecate! date: "2023-01-21", because: :unmaintained

  depends_on "sdl12-compat"
  depends_on "sdl_gfx"
  depends_on "sdl_image"
  depends_on "sdl_ttf"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"xsw", "-v"
  end
end
