class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "https://downloads.sourceforge.net/project/simutrans/simutrans/120-3/simutrans-src-120-3.zip"
  version "120.3"
  sha256 "6f68785798688bf956b0d7f5971a8d8fa42d12199011665b07b903164cb3929f"
  head "https://github.com/aburch/simutrans.git"

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
    url "https://downloads.sourceforge.net/project/simutrans/pak64/120-3/simupak64-120-3.zip"
    sha256 "332ff947fdddf99e0c9b67d857b1ffd02c91dfea1edc98f4195ec1f1309060f5"
  end

  resource "text" do
    url "https://simutrans-germany.com/translator/data/tab/language_pack-Base+texts.zip"
    sha256 "9c125325e14c6f19a5f6712be7267754e171565a5f49a185ed0b0edea774be0a"
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
