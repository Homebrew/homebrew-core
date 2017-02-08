class Simutrans < Formula
  desc "Transport simulator"
  homepage "http://www.simutrans.com/"
  url "https://downloads.sourceforge.net/project/simutrans/simutrans/120-1-3/simutrans-src-120-1-3.zip"
  version "120.1.3"
  sha256 "2d29b849fc39d25a0580091e1377270bddb2cae36c0fc32bd7c2d0f1d7ccfb84"
  head "https://github.com/aburch/simutrans.git"

  option "with-makeobj", "Build makeobj tool"

  depends_on "libpng" if build.with? "makeobj"
  depends_on "sdl2"

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/120-1/simupak64-120-1-2.zip"
    sha256 "125fa5c13a51bb0630ca651fddb8af06a823e8c4d4638bfa1bb2d89e92cc1d54"
  end

  resource "text" do
    url "http://simutrans-germany.com/translator/data/tab/language_pack-Base+texts.zip"
    sha256 "4c711c343db25e4055bf62b54c3bd8d96da5d43148db1c7767a72e586336790b"
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

    if build.with? "makeobj"
      system "make", "makeobj", *args
      bin.install "build/default/makeobj/makeobj"
    end
  end

  test do
    system "#{bin}/simutrans", "--help"
  end
end
