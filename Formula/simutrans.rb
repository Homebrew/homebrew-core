class Simutrans < Formula
  desc "Transport simulator"
  homepage "http://www.simutrans.com/"
  url "https://downloads.sourceforge.net/project/simutrans/simutrans/120-1-3/simutrans-src-120-1-3.zip"
  version "120.1.3"
  sha256 "202816f67750cfb9decdfca3bacfebbc5bfc3474c8703239418edc093ce3774d"
  head "https://github.com/aburch/simutrans.git"

  bottle do
    cellar :any
    sha256 "3ec72849c7370772e47897a09fe0dd704ab2c0cc2800b1599c18cac9c0a8a073" => :el_capitan
    sha256 "00e6e8a41c72ae7c9e0cec181238936e56aac1dfd4d3fa232a39604eb59ec79d" => :yosemite
    sha256 "db0ed05ffea3b6d5abdf73d2576cdea74827cd8af7e0f4de128afff30c1a8c27" => :mavericks
  end

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
