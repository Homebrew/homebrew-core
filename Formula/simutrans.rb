class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "https://downloads.sourceforge.net/project/simutrans/simutrans/121-0/simutrans-src-121-0.zip"
  version "121.0"
  sha256 "69fd95989761a013729106b48135f772f59126398cd93ada072f963c4d1e86b8"
  license "Artistic-1.0"
  head "https://github.com/aburch/simutrans.git"

  bottle do
    cellar :any
    sha256 "c2c9d281769baf57a160d47af3a8e0575912f8823f11e305e0f42c380759c7d6" => :catalina
    sha256 "227e7f7ac0becc49570846825ed6fb3a484c85741a2289216842066e225dd8c0" => :mojave
    sha256 "25efa70edc3b5b9270e4f6cc1bc40010ed5a427e081ed6810dc69151b47d9dac" => :high_sierra
  end

  depends_on "libpng"
  depends_on "sdl2"

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/121-0/simupak64-121-0.zip"
    sha256 "acd44278650944cd197ef8d5da7106f3d26c5fd3c3f2586c83a1c286e02c63cc"
  end

  resource "text" do
    url "https://simutrans-germany.com/translator/data/tab/language_pack-Base+texts.zip"
    sha256 "4592e14f0e32b044c613d2a51f7783a242ed751be67fdb65c46e136116d76d96"
  end

  def install
    args = %w[
      BACKEND=sdl2
      COLOUR_DEPTH=16
      MULTI_THREAD=1
      OSTYPE=mac
    ]
    args << "AV_FOUNDATION=1" if MacOS.version >= :sierra
    system "make", *args
    libexec.install "build/default/sim" => "simutrans"
    libexec.install Dir["simutrans/*"]
    bin.write_exec_script libexec/"simutrans"

    libexec.install resource("pak64")
    (libexec/"text").install resource("text")

    system "make", "makeobj", *args
    bin.install "build/default/makeobj/makeobj"
  end

  test do
    system "#{bin}/simutrans", "--help"
  end
end
