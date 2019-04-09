class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "https://downloads.sourceforge.net/project/simutrans/simutrans/120-4-1/simutrans-src-120-4-1.zip"
  version "120.4.1"
  sha256 "2cee0d067b3b72fa3a8b4ff31ad2bf5fc77521e7ba8cf9aa10e07e56b7dc877b"
  head "https://github.com/aburch/simutrans.git"

  bottle do
    cellar :any
    sha256 "90c296d4cb7f0be11f7c5135ebfb4cd52c11f8b884b5214ba03e996d2b2fc568" => :mojave
    sha256 "946b9f1861cf92328868acf0da83ff10bd031be0630260c06a2f35c7d226e7b0" => :high_sierra
    sha256 "cc225c3f51210e7b8cb056f5e41809bfc3f23ba2b96f406b10027a09632f313d" => :sierra
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
