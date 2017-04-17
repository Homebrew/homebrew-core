class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  head "https://github.com/aburch/simutrans.git"

  stable do
    url "https://downloads.sourceforge.net/project/simutrans/simutrans/120-1-3/simutrans-src-120-1-3.zip"
    version "120.1.3"
    sha256 "2d29b849fc39d25a0580091e1377270bddb2cae36c0fc32bd7c2d0f1d7ccfb84"

    # Port Mac audio code from QTKit to AVFoundation
    # Required since 10.12 SDK no longer includes QTKit.
    # Submitted upstream: https://forum.simutrans.com/index.php?topic=16675.0
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/bea80842a6ccc5639341add0d8abbca2d49b04c2/simutrans/avfoundation.patch"
      sha256 "9b9c9e6d89de49f152faaf584fcbbeec628bb07315b7c767e1f8b6791ad1e3ee"
    end
  end

  bottle do
    cellar :any
    sha256 "d07c63fcaa13fa5c670f27603cc0609a46da912374e30bd1e785329db26e7651" => :sierra
    sha256 "36961b1c305e6c2081447e54a274d0e118df63eb771626be1dc511b9c34811ed" => :el_capitan
    sha256 "200ce8fa5e825a6f49ac4f6d87a014bad0d6a4a16a7640a71261ac7680472ab1" => :yosemite
  end

  depends_on :macos => :lion
  depends_on "libpng"
  depends_on "sdl2"

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/120-1/simupak64-120-1-2.zip"
    sha256 "125fa5c13a51bb0630ca651fddb8af06a823e8c4d4638bfa1bb2d89e92cc1d54"
  end

  resource "text" do
    url "http://simutrans-germany.com/translator/data/tab/language_pack-Base+texts.zip"
    sha256 "202816f67750cfb9decdfca3bacfebbc5bfc3474c8703239418edc093ce3774d"
  end

  def install
    args = %w[
      BACKEND=sdl2
      COLOUR_DEPTH=16
      OSTYPE=mac
    ]
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
