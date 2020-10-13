class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "svn://servers.simutrans.org/simutrans/trunk/", revision: "9274"
  version "122.0"
  license "Artistic-1.0"
  head "https://github.com/aburch/simutrans.git"

  livecheck do
    url "https://sourceforge.net/projects/simutrans/files/simutrans/"
    strategy :page_match
    regex(%r{href=.*?/files/simutrans/(\d+(?:[-_.]\d+)+)/}i)
  end

  bottle do
    cellar :any
    sha256 "c2c9d281769baf57a160d47af3a8e0575912f8823f11e305e0f42c380759c7d6" => :catalina
    sha256 "227e7f7ac0becc49570846825ed6fb3a484c85741a2289216842066e225dd8c0" => :mojave
    sha256 "25efa70edc3b5b9270e4f6cc1bc40010ed5a427e081ed6810dc69151b47d9dac" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "sdl2"

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/122-0/simupak64-122-0.zip"
    sha256 "ce2ebf0e4e0c8df5defa10be114683f65559d5a994d1ff6c96bdece7ed984b74"
  end

  resource "text" do
    url "https://simutrans-germany.com/translator/data/tab/language_pack-Base+texts.zip"
    sha256 "a2078e40a96afbdaff4e192fd8cdfcb5b9c367f1b135e926335023abd9280152"
  end

  def install
    args = %w[
      BACKEND=sdl2
      MULTI_THREAD=1
      OPTIMISE=1
      OSTYPE=mac
      USE_FREETYPE=1
      USE_UPNP=0
      USE_ZSTD=0
    ]
    args << "AV_FOUNDATION=1" if MacOS.version >= :sierra
    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}", "CC=#{ENV.cc}"
    system "make", "all", *args
    cd "themes.src" do
      ln_s "../makeobj/makeobj", "makeobj"
      system "./build_themes.sh"
    end

    libexec.install "sim" => "simutrans"
    libexec.install Dir["simutrans/*"]
    bin.write_exec_script libexec/"simutrans"
    bin.install "makeobj/makeobj"
    bin.install "nettools/nettool"

    libexec.install resource("pak64")
    (libexec/"text").install resource("text")
  end

  test do
    system "#{bin}/simutrans", "--help"
  end
end
