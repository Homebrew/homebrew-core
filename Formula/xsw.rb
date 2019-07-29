class Xsw < Formula
  desc "Slide show presentation tool"
  homepage "https://code.google.com/archive/p/xsw/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/xsw/xsw-0.3.5.tar.gz"
  sha256 "d7f86047716d9c4d7b2d98543952d59ce871c7d11c63653f2e21a90bcd7a6085"

  bottle do
    sha256 "ea85521cec4aed7642dd1c5c4e1d44532292064c4ea1ca4d3bfd4a779484b428" => :mojave
    sha256 "09e57751cad18711cdc71cf47442366fda1bdb0adf6d156605c0ad2cc49be4fd" => :high_sierra
    sha256 "02e0d7c1f309b1743d11555af5601ddbf462c835e81f6188dd3f46835978a86a" => :sierra
    sha256 "b7a6391cf0df4a4d514a33188dc67a8fac551a3f66e82da626c4d4877cfe5274" => :el_capitan
    sha256 "8652e603fa053db1bfedeebad3699f6c77158a7133b55b37cea9ac33981aec8f" => :yosemite
    sha256 "3bd5da94a5c179f2cb40fdb8f385d0baeaed2a88aceb0f7a3839a9c6c605549f" => :mavericks
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
