class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "https://downloads.sourceforge.net/project/simutrans/simutrans/120-4/simutrans-src-120-4.zip"
  version "120.4"
  sha256 "cf0f364a26d178d9fbee8ec59196b308c811f1c1c69f45c05cdb554e58b61898"
  head "https://github.com/aburch/simutrans.git"

  bottle do
    cellar :any
    sha256 "5a6c026584d0519b0b7adf626a4f7b0b7d7689615de27241232593569a906868" => :mojave
    sha256 "d20fe9c5a2039bd438fd6f96e24979424acc9c1e7e442d9496ecd1a244640211" => :high_sierra
    sha256 "e4ac8b4e3ece8ee265e46419db351cba744c6b66b89683d3443ab35e65b936cd" => :sierra
    sha256 "0c7270b180b815014d92577de3e255d247f422ada4545e0c836bcaafa9a0b94b" => :el_capitan
  end

  depends_on "libpng"
  depends_on :macos => :lion
  depends_on "sdl2"

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/120-4/simupak64-120-4.zip"
    sha256 "b1dba2876838fcda6fb1b90c9b981e2aa490c1b0a81bab7c53b8bd50f59c0ffd"
  end

  resource "text" do
    url "https://simutrans-germany.com/translator/data/tab/language_pack-Base+texts.zip"
    sha256 "44caa98599089f55d5cfef34d24f9b8ae362d0b41c784ca1b649270436cdea02"
  end

  def install
    args = %w[
      BACKEND=sdl2
      COLOUR_DEPTH=16
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
