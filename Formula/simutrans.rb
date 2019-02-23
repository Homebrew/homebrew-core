class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "https://downloads.sourceforge.net/project/simutrans/simutrans/120-4-1/simutrans-src-120-4-1.zip"
  version "120.4.1"
  sha256 "2cee0d067b3b72fa3a8b4ff31ad2bf5fc77521e7ba8cf9aa10e07e56b7dc877b"
  head "https://github.com/aburch/simutrans.git"

  bottle do
    cellar :any
    sha256 "5a6c026584d0519b0b7adf626a4f7b0b7d7689615de27241232593569a906868" => :mojave
    sha256 "d20fe9c5a2039bd438fd6f96e24979424acc9c1e7e442d9496ecd1a244640211" => :high_sierra
    sha256 "e4ac8b4e3ece8ee265e46419db351cba744c6b66b89683d3443ab35e65b936cd" => :sierra
    sha256 "0c7270b180b815014d92577de3e255d247f422ada4545e0c836bcaafa9a0b94b" => :el_capitan
  end

  depends_on "libpng"

  depends_on "sdl2"

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/120-4-1/simupak64-120-4-1.zip"
    sha256 "fb46cde683ee1c0d10fb18bb2efc767583f1e9e76776a5f93d46a17d699aa69f"
  end

  resource "text" do
    url "https://simutrans-germany.com/translator/data/tab/language_pack-Base+texts.zip"
    sha256 "2a3cee3ef7cfbed31236c920502369446100c10c9304a476b2a885b4daae426a"
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
