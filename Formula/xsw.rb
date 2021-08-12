class Xsw < Formula
  desc "Slide show presentation tool"
  homepage "https://code.google.com/archive/p/xsw/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/xsw/xsw-0.3.5.tar.gz"
  sha256 "d7f86047716d9c4d7b2d98543952d59ce871c7d11c63653f2e21a90bcd7a6085"
  license "GPL-3.0"

  bottle do
    sha256 arm64_big_sur: "88ea32bb62da06d34a0f53679f4b2eae886527dcbd2a20d316b9950c516e88cf"
    sha256 big_sur:       "ca902b972fa913fc6c0f8e906c86986702d91e4383ceb5b017aae143d681121b"
    sha256 catalina:      "76084ad086c4635e308c84ed975d5249e8338207614b1b48f27c014611d913e6"
    sha256 mojave:        "ea85521cec4aed7642dd1c5c4e1d44532292064c4ea1ca4d3bfd4a779484b428"
    sha256 high_sierra:   "09e57751cad18711cdc71cf47442366fda1bdb0adf6d156605c0ad2cc49be4fd"
    sha256 sierra:        "02e0d7c1f309b1743d11555af5601ddbf462c835e81f6188dd3f46835978a86a"
    sha256 el_capitan:    "b7a6391cf0df4a4d514a33188dc67a8fac551a3f66e82da626c4d4877cfe5274"
    sha256 yosemite:      "8652e603fa053db1bfedeebad3699f6c77158a7133b55b37cea9ac33981aec8f"
    sha256 x86_64_linux:  "94274156a1fbb7c7c13a36ed0ededbad7cca62427ff73c7b8450ff2f7d8ecc99"
  end

  depends_on "sdl"
  depends_on "sdl_gfx"
  depends_on "sdl_image"
  depends_on "sdl_ttf"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"xsw", "-v"
  end
end
