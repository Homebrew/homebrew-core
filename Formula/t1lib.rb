class T1lib < Formula
  desc "C library to generate/rasterize bitmaps from Type 1 fonts"
  homepage "https://www.t1lib.org/"
  url "https://www.ibiblio.org/pub/linux/libs/graphics/t1lib-5.1.2.tar.gz"
  mirror "https://fossies.org/linux/misc/old/t1lib-5.1.2.tar.gz"
  sha256 "821328b5054f7890a0d0cd2f52825270705df3641dbd476d58d17e56ed957b59"

  bottle do
    rebuild 2
    sha256 "2fc10925d1618b809de806ee87722c96d8c03655e3d586f0a37b3d049ee2e082" => :mojave
    sha256 "a36bc3913f6b51cb7772609a52049f90fc6241ffca3bf18c4295455ef5f4df4c" => :high_sierra
    sha256 "94789287c849a04f05a40c79940aee6efe3e03318c95db9c2be69ee4e6806d82" => :sierra
    sha256 "fa356a5405f5b0cf57c15ebd5b680c215e1e498189914e9b9663eb132655a8c1" => :el_capitan
    sha256 "6d1bf242eb7a5201180b9d4b505a7f83663802383d358180cea696714ae57fc8" => :yosemite
    sha256 "ec107b30d4b9a95bbc094a7a944cab862ed78a875c5ed0002aa7232ec514e9d7" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "without_doc"
    system "make", "install"
    share.install "Fonts" => "fonts"
  end
end
